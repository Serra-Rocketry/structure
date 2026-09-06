// ============================================================================
// Acoplador de módulos — Dédalo SR4-1000 (rascunho v0.3 — rosca quadrada)
//
// Dois anéis que se acoplam:
//   - MACHO: espiga longa com rosca externa, entra quase no comprimento todo
//            da fêmea
//   - FÊMEA: boca com rosca interna que recebe a espiga
//
// ⚠️ VALORES CHUTADOS — ajustar com as medidas reais.
// Falta: furos p/ inserts de latão (#10) e reforço da região fina (#11).
//
// HISTÓRICO de decisão técnica (2026-09-06):
//   - v0.1 usava threads.scad da equipe (altimeter-egg, Ryan Colyer CC0).
//     Com Ø94 + comprimento 54 o polyhedron helicoidal do lib se FRAGMENTA
//     (filetes soltos do núcleo; 23 volumes no macho sozinho) e o CGAL leva
//     10+ min. Testado: resolução 0.2→1.2 não resolve; tip cônica não é a
//     causa. Lib foi desenhado p/ parafusos pequenos (M3-M10).
//   - v0.3: rosca QUADRADA própria via linear_extrude(twist) — uma peça só,
//     resolução controlada, e perfil quadrado é melhor p/ FDM (flanco 90°
//     aguenta mais carga e delamina menos que V fino).
// ============================================================================

// ---------- CONFIG (editar aqui) ----------
tipo_encaixe = "rosca"; // opção de acoplamento: "rosca" (implementado) | "baioneta" (FUTURO)

od_peca      = 99.6; // OD do acoplador [mm] — hipótese: entra no tubo (ID do tubo = 100, folga p/ cola)
furo_interno = 84;   // furo interno contínuo [mm] — passagem; parede grossa dá material p/ rosca robusta
comp_macho   = 60;   // corpo do macho (região que fica colada no tubo A) [mm]
comp_femea   = 60;   // corpo da fêmea (região que fica colada no tubo B) [mm]

// Rosca — QUADRADA, grossa e robusta (impressão FDM)
// ⚠️ OpenSCAD: linear_extrude com twist só fecha a malha com NÚMERO INTEIRO
//    de voltas (bug: volta fracionária deixa mesh aberta). Por isso o
//    comprimento da rosca é derivado de voltas × passo, não livre.
passo_rosca  = 8;     // passo [mm] — grosso
voltas_rosca = 7;     // voltas da rosca (inteiro!) — 7 × 8 = 56 mm
espiga_comp  = voltas_rosca * passo_rosca;  // comprimento rosqueado [mm]
rosca_od     = 94;    // diâmetro de crista da rosca macho [mm]
rosca_prof   = 1.5;   // profundidade radial do filete [mm]
rosca_id     = rosca_od - 2 * rosca_prof;  // diâmetro de raiz (derivado) [mm]
larg_groove  = passo_rosca * 0.45;  // largura axial do vão (groove) [mm]
rosca_tol    = 0.4;   // folga radial p/ rosquear [mm]
recesso_prof = espiga_comp;  // profundidade da rosca interna na fêmea [mm]
                             // (56 de 60 do corpo — 4 mm de folga no fundo)
fn_rosca     = 144;   // segmentos do círculo da rosca

// Visualização
exploded      = true;  // true: peças separadas no eixo Z
sep           = 70;    // distância de separação [mm] — > altura do macho (116)
somente_macho = false; // DEBUG: true exporta só o macho (isolar problema de malha)

$fn_res = 96;  // resolução das superfícies curvas

// ============================================================================
// BAIONETA — ACOPLAMENTO ALTERNATIVO (FUTURO, NÃO IMPLEMENTADO)
// ============================================================================
// Ideia: em vez de rosca helicoidal, encaixe de baioneta (puxa-e-gira):
//   - macho: espiga com PINOS radiais (2 ou 3)
//   - fêmea: boca com RANHURAS em L (entrada axial + giro de ~90° que trava)
// Vantagem: montagem mais rápida em campo, sem rosquear N voltas; menos
// desgaste por fricção do filete (relacionado à #10).
// Parâmetros a definir quando implementar (esqueleto):
//   // qtd_pinos      = 3;         // pinos na espiga (120° entre si)
//   // pino_d         = 6;         // diâmetro do pino [mm]
//   // ranhura_larg   = pino_d + 0.6;  // largura da ranhura [mm]
//   // ranhura_axial  = 20;        // trecho axial de entrada [mm]
//   // ranhura_giro   = 90;        // arco de giro até travar [graus]
//   // trava_alt      = 2;         // relevo/ressalto no fim do giro (clique)
// Nota: pino pode ser impresso junto (risco de cisalhamento) ou insert
// metálico passante (#10 já prevê inserts de latão — avaliar pino metálico).
// Módulos a criar (quando implementar):
//   module macho_baioneta()  { ... }   // espiga + pinos
//   module femea_baioneta()  { ... }   // boca + ranhuras em L (rotate_extrude p/ arco)
// ============================================================================

// ---------- Módulos ----------
module anel(od, id, h) {
    difference() {
        cylinder(d = od, h = h, $fn = $fn_res);
        translate([0, 0, -0.1])
            cylinder(d = id, h = h + 0.2, $fn = $fn_res);
    }
}

// ---------------------------------------------------------------------------
// ROSCA QUADRADA (uma partida) — módulo próprio (ver histórico no topo).
//
// Gera um CILINDRO rosqueado: disco de raio_crista com RANHURA helicoidal
// quadrada (setor anular removido com arcos de verdade, do raio_raiz até a
// crista, girado por linear_extrude com twist). A secção NÃO tem furo
// interno nem usa circle() com T-junctions: o contorno é um polígono único
// (arco externo + arco interno + 2 raios) — malha fecha. O furo central é
// removido depois com difference() de um cilindro concêntrico simples.
//
// raio_crista  : raio externo do filete (topo)
// raio_raiz    : raio do fundo da ranhura (a partir daqui o material é cheio)
// alt          : comprimento do trecho rosqueado (Nº INTEIRO de voltas)
// passo        : avanço axial por volta completa [mm]
// groove_ax    : largura axial da ranhura helicoidal [mm] (< passo)
// ---------------------------------------------------------------------------

// Amostra um arco de raio r entre a0..a1 (graus) em n segmentos
function pts_arco(r, a0, a1, n) = [
    for (i = [0:n])
        let(a = a0 + (a1 - a0) * i / n)
            [r * cos(a), r * sin(a)]
];

module cilindro_roscado(raio_crista, raio_raiz, alt, passo, groove_ax) {
    ang_groove = 360 * groove_ax / passo;  // ângulo do setor removido
    voltas     = alt / passo;
    slices     = ceil(voltas) * 36;  // 36 fatias por volta (~10°) — fechamento ok

    // amostragem dos arcos: ~3° (segmento ≈ 2.5 mm no Ø94)
    n_ext = max(8, ceil((360 - ang_groove) / 3));
    n_int = max(8, ceil(ang_groove / 3));

    secao_pts = concat(
        // arco externo (crista) do fim da ranhura até 360°
        pts_arco(raio_crista, ang_groove, 360, n_ext),
        // desce no raio 0°/360° até a raiz
        [[raio_raiz * cos(360), raio_raiz * sin(360)]],
        // arco interno (raiz) de 0° até o fim da ranhura
        pts_arco(raio_raiz, 0, ang_groove, n_int),
        // sobe no raio ang_groove até a crista (fecha o laço)
        [[raio_crista * cos(ang_groove), raio_crista * sin(ang_groove)]]
    );

    linear_extrude(height = alt, twist = voltas * 360, slices = slices,
                   convexity = 10)
        polygon(points = secao_pts);
}

module macho() {
    // corpo (cola no tubo A)
    anel(od_peca, furo_interno, comp_macho);

    if (tipo_encaixe == "rosca") {
        // Espiga rosqueada (cilindro cheio com ranhura) menos o furo interno.
        // Overlap de 0.01 p/ não deixar face coplanar com o topo do corpo.
        translate([0, 0, comp_macho - 0.01])
            difference() {
                cilindro_roscado(rosca_od / 2, rosca_id / 2,
                                 espiga_comp, passo_rosca, larg_groove);
                translate([0, 0, -0.1])
                    cylinder(d = furo_interno, h = espiga_comp + 0.3, $fn = $fn_res);
            }
    }
    // TODO(baioneta): if (tipo_encaixe == "baioneta") { macho_baioneta(); }
}

module femea() {
    if (tipo_encaixe == "rosca") {
        // Boca (base, virada p/ baixo) com rosca interna:
        // subtrai o mesmo cilindro rosqueado, alargado pela folga radial.
        // (o cilindro cobre o centro — o anel já é vazado no furo_interno)
        raio_crista_f = rosca_od / 2 + rosca_tol;   // fundo da ranhura interna
        raio_raiz_f   = rosca_id / 2 - rosca_tol;   // topo do filete interno
        difference() {
            anel(od_peca, furo_interno, comp_femea);
            translate([0, 0, -0.01])
                cilindro_roscado(raio_crista_f, raio_raiz_f,
                                 recesso_prof, passo_rosca, larg_groove);
        }
    } else {
        // baioneta (futuro): boca com ranhuras em L, sem rosca
        anel(od_peca, furo_interno, comp_femea);
        // TODO(baioneta): if (tipo_encaixe == "baioneta") { femea_baioneta(); }
    }
}

// ---------- Montagem ----------
if (somente_macho) {
    color("tomato") macho();
} else if (exploded) {
    color("tomato")  macho();
    color("skyblue") translate([0, 0, comp_macho + sep]) femea();
} else {
    color("tomato")  macho();
    color("skyblue") translate([0, 0, comp_macho]) femea();
}
