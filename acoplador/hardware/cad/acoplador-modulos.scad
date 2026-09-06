// ============================================================================
// Acoplador de módulos — estrutura genérica Serra Rocketry (v0.6 — rosca passo 30 + tirantes anti-delaminação)
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
//   - v0.4: passo 8 → 16 mm (2×) — ângulo de hélice 3.1° (era 1.55°), filete
//     mais grosso e visível; 4 voltas × 16 = 64 mm de engate.
//   - v0.5: passo 16 → 30 mm c/ só 2 voltas (escolha do Angelo: ângulo >,
//     poucas voltas) — ângulo de hélice 5.8°, engate 60 mm, prof filete 2.5.
//   - v0.6: tirantes anti-delaminação SÓ no macho (Angelo: em FDM a adesão
//     entre camadas é o elo fraco — parafusos longitudinais costuram os
//     círculos das camadas XY, do corpo E da espiga). 3 bosses (protuberân-
//     cias suaves) na parede INTERNA a 120°, do corpo até quase o topo da
//     rosca. CABEÇA allen embutida no topo da espiga (margem_topo, fêmea
//     rosqueia por fora e não toca); PORCA travada em bolsão hex embutido na
//     coroa inferior (margem_fundo). Aperto pela chave allen no topo com a
//     fêmea desrosqueada. Tamanho é PARÂMETRO: parafuso_m = 3/4/5 (M3/M4/M5).
//     Furo interno 84→80 p/ dar parede (9.8mm) e reforçar a rosca.
//     Detalhes e motivação: ver acoplador-modulos.md
// ============================================================================

// ---------- CONFIG (editar aqui) ----------
tipo_encaixe = "rosca"; // opção de acoplamento: "rosca" (implementado) | "baioneta" (FUTURO)

od_peca      = 99.6; // OD do acoplador [mm] — hipótese: entra no tubo (ID do tubo = 100, folga p/ cola)
furo_interno = 80;   // furo interno contínuo [mm] — passagem; v0.6: 84→80 p/ dar parede
                     // (9.8mm) pros tirantes M3 e reforçar a rosca (raiz Ø89 → parede 4.5mm)
comp_macho   = 60;   // corpo do macho (região que fica colada no tubo A) [mm]
comp_femea   = 64;   // corpo da fêmea (região que fica colada no tubo B) [mm] — 60 recesso + 4 parede

// Tirantes anti-delaminação (SÓ no macho) — ver histórico v0.6 no topo
// 3 bosses (protuberâncias suaves) na parede INTERNA, a 120°, do corpo até
// quase o topo da ROSCA (costuram as camadas do corpo E da espiga). CABEÇA
// allen embutida no topo da espiga, N mm abaixo da face (margem_topo —
// acabamento; fêmea rosqueia por fora e não toca); PORCA travada em bolsão
// hexagonal embutido na coroa inferior (margem_fundo). Aperto: chave allen
// pelo topo da espiga com a fêmea desrosqueada. Parafuso rosca total longo
// (barra roscada + porca ou DIN912 rosca total).
parafuso_m    = 3;    // tirante: 3 = M3, 4 = M4, 5 = M5 (parâmetro!)
margem_topo   = 2.0;  // cabeça fica N mm abaixo da face do topo da espiga [mm]
margem_fundo  = 1.0;  // porca fica N mm acima da coroa inferior [mm]

// Tabela por tamanho — índice [parafuso_m - 3]:
//   M3          M4          M5
pf_furo     = [ 3.4,       4.5,       5.5    ][parafuso_m - 3]; // furo passante (broca)
pf_cabeca_d = [ 5.5,       7.0,       8.5    ][parafuso_m - 3]; // Ø cabeça allen DIN912
pf_cabeca_h = [ 3.0,       4.0,       5.0    ][parafuso_m - 3]; // altura da cabeça
pf_porca_s  = [ 5.5,       7.0,       8.0    ][parafuso_m - 3]; // porca across flats
pf_porca_h  = [ 2.4,       3.2,       4.0    ][parafuso_m - 3]; // altura da porca
// boss do CORPO: grosso (cabe a porca no bolsão da coroa inferior)
boss_centro = 40.0;  // raio do centro do boss [mm] — na parede do furo (Ø80)
boss_d      = [16.0,      18.0,      19.5   ][parafuso_m - 3]; // Ø boss no corpo [mm]
// boss da ESPIGA: fino (não pode invadir a raiz da rosca Ø89/2=44.5)
boss_esp_d  = [ 9.0,       9.0,       9.0    ][parafuso_m - 3]; // Ø boss na espiga [mm]
tirante_r   = 40.0;  // raio do furo do tirante (= centro do boss) [mm]
parafuso_n  = 3;     // nº de tirantes (120° entre si)
// ⚠️ M5: cabeça Ø8.5+0.6 = 9.1 > boss_esp_d 9.0 — rebaixo no topo da espiga
//    quase não fecha. Se for usar M5, aumentar boss_esp_d p/ ~10.2 (invade
//    0.2mm a raiz da rosca localmente) ou aceitar rebaixo raso. M3/M4 ok.
// (furo central livre: M3≈64 no corpo / ≈71 na espiga — avisar no changelog)

// Rosca — QUADRADA, grossa e robusta (impressão FDM)
// ⚠️ OpenSCAD: linear_extrude com twist só fecha a malha com NÚMERO INTEIRO
//    de voltas (bug: volta fracionária deixa mesh aberta). Por isso o
//    comprimento da rosca é derivado de voltas × passo, não livre.
// v0.4: passo 16 (2× o v0.3) p/ ângulo de hélice mais visível e filete
//       mais grosso; 4 voltas × 16 = 64 mm de engate (v0.3: 7 × 8 = 56).
// v0.5: passo 30 com 2 voltas (poucas, decidido c/ Angelo) — ângulo de
//       hélice 5.8° (visível); engate 2 × 30 = 60 mm; prof do filete 2.5.
passo_rosca  = 30;    // passo [mm] — grosso, ângulo de hélice visível
voltas_rosca = 2;     // voltas da rosca (inteiro!) — 2 × 30 = 60 mm
espiga_comp  = voltas_rosca * passo_rosca;  // comprimento rosqueado [mm]
rosca_od     = 94;    // diâmetro de crista da rosca macho [mm]
rosca_prof   = 2.5;   // profundidade radial do filete [mm]
rosca_id     = rosca_od - 2 * rosca_prof;  // diâmetro de raiz (derivado) [mm]
larg_groove  = passo_rosca * 0.45;  // largura axial do vão (groove) [mm]
rosca_tol    = 0.4;   // folga radial p/ rosquear [mm]
recesso_prof = espiga_comp;  // profundidade da rosca interna na fêmea [mm]
                             // (60 de 64 do corpo — 4 mm de parede no fundo)
fn_rosca     = 144;   // segmentos do círculo da rosca

// Visualização
exploded      = true;  // true: peças separadas no eixo Z
sep           = 160;   // distância de separação [mm] — > altura do macho (132)
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
    difference() {
        union() {
            // corpo (cola no tubo A)
            anel(od_peca, furo_interno, comp_macho);

            // 3 bosses no CORPO (parede interna, a 120°) — engrossam p/ dentro
            // e dão material ao redor do furo do tirante na região colada.
            for (i = [0:parafuso_n - 1]) {
                ang = i * 360 / parafuso_n;
                rotate([0, 0, ang])
                    translate([boss_centro, 0, 0])
                        cylinder(d = boss_d, h = comp_macho, $fn = $fn_res);
            }

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

                // Bosses na ESPIGA: continuação dos bosses do corpo até o topo
                // da rosca (costuram as camadas da espiga). Finos (Ø 9) p/ não
                // invadir a raiz da rosca (Ø89 → raio 44.5).
                for (i = [0:parafuso_n - 1]) {
                    ang = i * 360 / parafuso_n;
                    rotate([0, 0, ang])
                        translate([boss_centro, 0, comp_macho - 0.01])
                            cylinder(d = boss_esp_d,
                                     h = espiga_comp + 0.01,
                                     $fn = $fn_res);
                }
            }
            // TODO(baioneta): if (tipo_encaixe == "baioneta") { macho_baioneta(); }
        }

        // Furos dos tirantes atravessam corpo + espiga (até margem_topo do topo)
        tirantes_macho();
    }
}

// Tirantes anti-delaminação do macho: 3 parafusos longitudinais (M3/M4/M5,
// ver parafuso_m) que atravessam corpo + espiga no centro de cada boss
// (costuram as camadas FDM do corpo E da espiga — elo fraco em Z). CABEÇA
// allen embutida no TOPO da espiga, margem_topo abaixo da face (a fêmea
// rosqueia por fora e não toca; aperto com a fêmea desrosqueada); PORCA
// travada em bolsão hexagonal embutido na coroa inferior (margem_fundo).
// Parafuso de rosca total longo (barra roscada + porca ou DIN912 rosca
// total), broca pf_furo.
module tirantes_macho() {
    topo_furo = comp_macho + espiga_comp - margem_topo;  // onde a haste termina
    for (i = [0:parafuso_n - 1]) {
        ang = i * 360 / parafuso_n;
        translate([tirante_r * cos(ang), tirante_r * sin(ang), 0]) {
            // furo longitudinal passante (corpo + espiga), para antes do topo
            cylinder(d = pf_furo, h = topo_furo + 0.2, $fn = 32);
            // rebaixo da CABEÇA allen no topo da espiga (embutida margem_topo)
            translate([0, 0, topo_furo - pf_cabeca_h])
                cylinder(d = pf_cabeca_d + 0.6,
                         h = pf_cabeca_h + margem_topo + 0.2, $fn = 32);
            // bolsão HEXAGONAL da porca (coroa inferior; across flats pf_porca_s)
            // abre na face (z=0) p/ inserir a porca; fundo em pf_porca_h+margem_fundo
            // → porca aperta contra o fundo e fica embutida (não aparece na face)
            translate([0, 0, -0.05])
                cylinder(d = (pf_porca_s + 0.4) / cos(30),
                         h = pf_porca_h + margem_fundo + 0.1, $fn = 6);
        }
    }
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

// Parafusos de tirante representados (só visualização — hardware real)
module parafusos_tirante() {
    topo_furo  = comp_macho + espiga_comp - margem_topo;  // topo da haste
    z_base_has = topo_furo - pf_cabeca_h;                 // base da cabeça
    for (i = [0:parafuso_n - 1]) {
        ang = i * 360 / parafuso_n;
        translate([tirante_r * cos(ang), tirante_r * sin(ang), 0]) {
            // haste: da coroa inferior (z=0) até a base da cabeça (z≈115)
            cylinder(d = pf_furo - 0.4, h = z_base_has + 0.05, $fn = 24);
            // cabeça allen embutida no topo (margem_topo abaixo da face z=120)
            translate([0, 0, z_base_has])
                cylinder(d = pf_cabeca_d, h = pf_cabeca_h, $fn = 24);
            // porca no bolsão hexagonal da coroa inferior (embutida 1mm)
            translate([0, 0, margem_fundo])
                cylinder(d = pf_porca_s, h = pf_porca_h, $fn = 6);
        }
    }
}

// ---------- Montagem ----------
// Cores: macho sólido laranja; fêmea azul TRANSLÚCIDA (ver recesso interno)
// Parafusos cinza = tirantes M3 (hardware real, p/ visualizar posição)
// Montado: a fêmea rosqueia até o fim da rosca; a face dela encosta no ombro
// do macho (z=comp_macho). O furo central Ø80 é contínuo nas duas peças —
// é por ele que a chave allen longa desce p/ apertar os tirantes do macho.
alt_macho  = comp_macho + espiga_comp;  // 60+60 = 120
if (somente_macho) {
    color("darkorange", 1.0) macho();
} else if (exploded) {
    color("darkorange", 1.0)  macho();
    color("deepskyblue", 0.45) translate([0, 0, alt_macho + sep]) femea();
    color("silver", 0.9) parafusos_tirante();
} else {
    color("darkorange", 1.0)  macho();
    color("deepskyblue", 0.45) translate([0, 0, comp_macho]) femea();
    color("silver", 0.9) parafusos_tirante();
}
