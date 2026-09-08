// ============================================================================
// Acoplador de módulos — estrutura genérica Serra Rocketry (v0.10 — boss Ø16 uniforme corpo+espiga)
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
//   - v0.7: LÁBIO de batente de colagem (Angelo: "colocar um lábio bem fino,
//     p/ não entrar demais, na fêmea e no macho, p/ ajudar na hora de
//     colar"). Anel axial fino (labio_esp = 1mm; 0.4 possível) na borda
//     superior do corpo no ombro (macho) e na boca do recesso z=0 (fêmea).
//     OD do anel ≈ OD do tubo (103.6; tubo real ID 100/parede 2 = OD 104) →
//     flush por fora; o tubo encosta e trava a profundidade de colagem.
//   - v0.8: CHANFRO de guia 45° p/ facilitar o encontro/inserção (Angelo:
//     "um filete no topo da rosca, parte externa, e na parte de baixo da
//     fêmea, parte interna"). No MACHO: aresta externa do topo da espiga
//     (ponta entra afunilada); na FÊMEA: aresta interna da boca do recesso
//     (boca de sino). Tamanho paramétrico: chanfro_rosca = 2mm (45°).
//   - v0.9: PERFIL V 60° + ENCAIXE CORRIGIDO. (a) Angelo: perfil quadrado
//     (flanco 90°) é difícil de imprimir — flanco vira V 60° total (30° da
//     radial, rosca_ang_flank). (b) DESCOBERTA: desde o v0.3 o dente (55% do
//     passo) era MAIOR que o vão (45%) — par impossível de rosquear (renders
//     "montado" se intersectavam; nunca houve checagem de interferência).
//     Rebalanceado: vão 15.5 / dente 14.5 no raio médio (larg_groove 0.5167
//     do passo). (c) raio_raiz_f estava com SINAL ERRADO (−tol): fêmea com
//     dente alcançando DENTRO do raio do macho → agora +tol (folga radial
//     nos dois raios), e com o flanco V a folga radial vira folga axial de
//     flanco (~0.5mm). Validação nova: interferência/clearance entre o par.
//   - v0.9 (cont.): (d) malha do V inicial saiu FRAGMENTADA (7 comps) — slivers
//     de volume zero na junção flanco inclinado→núcleo. Fix: piso plano no
//     fundo do vão (rosca_fundo_flat, 0.3mm) — junção vira parede radial como
//     na v0.8, malha fecha limpa, e ainda evita ponta V na raiz (imprime
//     melhor). (e) folga axial no fundo do recesso (fundo_extra = 1mm de furo
//     liso Ø90): a fêmea assenta no ombro sem a ponta da espiga encostar no
//     fundo (recesso continua 2 voltas inteiras p/ o twist fechar). (f)
//     validação final por proximidade de malha na posição montada: sem
//     penetração; distância mínima 0.206mm = folga projetada da ponta do
//     dente da fêmea (r=45.0) ao início do flanco do macho (r=44.8).
//   - v0.10: BOSS Ø16 UNIFORME no corpo E na espiga (Angelo: "não tem lógica
//     uma parte mais fina"). A espiga era Ø9 p/ não invadir a raiz da rosca
//     (Ø89/2=44.5); com boss Ø16 centrado no tirante (r=40) o lado externo
//     iria a r=48, furando a rosca. Solução: mover tirante+boss p/ dentro —
//     boss_centro/tirante_r derivados da raiz (boss_centro = rosca_id/2 -
//     boss_d/2 - 0.5). M3: r=36 → boss outer 44 (0.5mm abaixo da raiz),
//     rosca intacta, furo central na altura dos bosses Ø56 (era Ø64/Ø71).
//     M4: r=35/Ø52, M5: r=34.25/Ø49. Removeu boss_esp_d (fim do Ø9).
// ============================================================================

// ---------- CONFIG (editar aqui) ----------
tipo_encaixe = "rosca"; // opção de acoplamento: "rosca" (implementado) | "baioneta" (FUTURO)

od_peca      = 99.6; // OD do acoplador [mm] — hipótese: entra no tubo (ID do tubo = 100, folga p/ cola)
furo_interno = 80;   // furo interno contínuo [mm] — passagem; v0.6: 84→80 p/ dar parede
                     // (9.8mm) pros tirantes M3 e reforçar a rosca (raiz Ø89 → parede 4.5mm)
comp_macho   = 60;   // corpo do macho (região que fica colada no tubo A) [mm]
comp_femea   = 64;   // corpo da fêmea (região que fica colada no tubo B) [mm] — 60 recesso + 4 parede

// ---------- Lábio de batente de colagem (v0.7) ----------
// Anel fino na boca de cada peça: na hora de colar, o tubo encosta no lábio
// e NÃO deixa a peça entrar demais (profundidade de colagem definida).
// Posição (confirmada c/ Angelo): MACHO — borda superior do corpo, no ombro
// (o tubo A termina aí); FÊMEA — boca do recesso, face z=0 (o tubo B termina).
// OD vai até perto do OD do tubo → fica flush por fora, invisível.
// labio_esp é o "bem fino" (0.4 possível); Angelo: default 1.
labio_on      = true;   // false p/ voltar ao v0.6 (sem lábio)
labio_esp     = 1.0;    // espessura AXIAL do anel [mm] (0.4 = 1 parede, frágil)
tubo_id       = 100;    // ID do tubo [mm] (folga de cola vs OD da peça 99.6)
tubo_parede   = 2.0;    // parede do tubo [mm] — REAL (Angelo, 2026-09-06)
tubo_od       = tubo_id + 2 * tubo_parede;  // OD do tubo [mm] (= 104)
labio_od      = tubo_od - 0.4;  // OD do lábio [mm] (103.6) — flush com o tubo
                                // menos folga p/ nunca passar do OD real

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
// boss do CORPO e da ESPIGA: MESMO diâmetro (v0.10 — Angelo: "não tem lógica
// uma parte mais fina"). Antes a espiga era Ø9 p/ não invadir a raiz da rosca
// (Ø89/2=44.5); com boss Ø16 centrado no tirante ele invadiria a rosca.
// Solução (v0.10): mover tirante+boss p/ dentro — boss_centro/tirante_r são
// DERIVADOS da raiz da rosca (ver bloco "rosca" abaixo). Aqui só o Ø do boss
// e a contagem.
boss_d      = [16.0,      18.0,      19.5   ][parafuso_m - 3]; // Ø boss [mm] (corpo = espiga)
parafuso_n  = 3;     // nº de tirantes (120° entre si)

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

// Centro do boss / furo do tirante — derivado da raiz da rosca (v0.10):
// o boss Øboss_d centrado no tirante não pode invadir a raiz da rosca
// (rosca_id/2 = 44.5). boss_centro = rosca_id/2 - boss_d/2 - 0.5 → o lado
// externo do boss fica 0.5mm ABAIXO da raiz e não toca a rosca.
//   M3: 44.5 - 8.0  - 0.5 = 36.0  → boss outer 44.0, furo central Ø56
//   M4: 44.5 - 9.0  - 0.5 = 35.0  → furo central Ø52
//   M5: 44.5 - 9.75 - 0.5 = 34.25 → furo central Ø49
boss_centro = rosca_id / 2 - boss_d / 2 - 0.5;
tirante_r   = boss_centro;
// v0.9: VÃO (largura axial do groove no RAIO MÉDIO) = 15.5 → DENTE 14.5.
// Antes era 0.45×passo = 13.5 (dente 16.5 > vão 13.5 = IMPOSSÍVEL de rosquear).
larg_groove  = passo_rosca * 0.5167;  // vão no raio médio [mm] (=15.5)
rosca_ang_flank = 30;  // flanco [graus] da radial: 0 = quadrada (v0.8),
                       // 30 = V 60° total (v0.9). V dá folga de flanco com a
                       // folga radial e imprime melhor que parede a 90°.
rosca_tol    = 0.5;   // folga radial do par [mm] (era 0.4). Com flanco V 30°,
                       // vira ~0.5mm de folga axial por flanco (folga FDM típica).
rosca_fundo_flat = 0.3; // piso plano no fundo do vão [mm] — evita ponta V na
                        // raiz (imprime melhor) e mantém a junção flanco→piso
                        // radial, que fecha malha sem slivers. 0.3 (era 0.5):
                        // 0.5 fazia o flanco começar em r=45.0 = raio da ponta
                        // do dente da fêmea (contato linha a linha)
recesso_prof = espiga_comp;  // profundidade ROSQUEADA da fêmea [mm]
                             // (= 60 = 2 voltas inteiras — twist fecha). A
                             // FOLGA AXIAL de 1mm fica num prolongamento de
                             // furo liso Ø90 no fundo (fundo_extra abaixo),
                             // p/ a ponta da espiga não encostar no fundo.
fn_rosca     = 144;   // segmentos do círculo da rosca
fundo_extra  = 1;     // folga axial no fundo do recesso [mm]: prolongamento
                      // de furo liso Ø90 além da rosca — a espiga (2 voltas =
                      // 60mm) assenta sem a ponta encostar no fundo

// Chanfro de guia (v0.8) — 45° nas duas pontas, p/ facilitar encontro/inserção
chanfro_on    = true;  // false p/ desligar (v0.7)
chanfro_rosca = 2.0;   // chanfro 45° [mm]: topo da rosca do macho (aresta
                       // externa da ponta) + boca do recesso da fêmea (aresta
                       // interna, z=0). ⚠️ na fêmea não passar da parede da
                       // boca (2.4mm sem lábio; com lábio vira 2.4 no aro).

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

// Amostra um arco de raio r entre a0..a1 (graus) em n segmentos — devolve
// n pontos SEM o ponto final (o próximo trecho começa onde este terminou).
function pts_arco(r, a0, a1, n) = [
    for (i = [0:n - 1])
        let(a = a0 + (a1 - a0) * i / n)
            [r * cos(a), r * sin(a)]
];

// Amostra a parede do FLANCO de (r0,a0) até (r1,a1) com θ linear em r:
// o flanco 3D (depois do twist) fica com inclinação constante (perfil V reto).
// Devolve n pontos SEM o ponto final (junção sem duplicata).
function pts_flank(r0, a0, r1, a1, n) = [
    for (i = [0:n - 1])
        let(t = i / n,
            r = r0 + (r1 - r0) * t,
            a = a0 + (a1 - a0) * t)
            [r * cos(a), r * sin(a)]
];

module cilindro_roscado(raio_crista, raio_raiz, alt, passo, groove_ax) {
    // Perfil do filete (v0.9): flanco inclinado `rosca_ang_flank`° da radial
    // (0 = quadrado; 30 = V 60° total). O vão tem `groove_ax` de largura
    // AXIAL no RAIO MÉDIO; com o flanco inclinado ele alarga na crista e
    // estreita na raiz (dente trapezoidal: mais fino em cima, mais grosso na
    // base — imprime sem parede a 90°). O vão tem PISO PLANO na raiz
    // (`rosca_fundo_flat`): evita ponta V no fundo (melhor p/ FDM e
    // resistência) e mantém a junção flanco→piso radial (malha sem slivers).
    ang_flank = rosca_ang_flank;
    d_r   = raio_crista - raio_raiz;              // profundidade radial
    raio_m = (raio_crista + raio_raiz) / 2;       // raio médio (largura = groove_ax)
    ang_m = 360 * groove_ax / passo;              // largura angular do vão no raio médio
    // variação angular de cada flanco da raiz → crista (largura do vão cresce 2×)
    d_ang = d_r * tan(ang_flank) * 360 / passo;
    // limites angulares do vão (centrado em ang_m/2), na crista e na raiz
    aC0 = ang_m / 2 - (ang_m + d_ang) / 2;   // crista: início do vão (pode ser <0)
    aC1 = ang_m / 2 + (ang_m + d_ang) / 2;   // crista: fim do vão
    flat  = rosca_fundo_flat;                // piso plano do vão (na raiz)
    rf    = raio_raiz + flat;                // raio onde o flanco termina (acima do piso)
    shift = d_ang * (1 - flat / d_r);        // deslocamento angular do flanco até o piso
    aLf   = aC0 + shift;                     // lado baixo do vão no fim do flanco
    aHf   = aC1 - shift;                     // lado alto do vão no fim do flanco
    voltas = alt / passo;
    slices = ceil(voltas) * 36;  // 36 fatias por volta (~10°) — fechamento ok

    // amostragem ~3° nos arcos do corpo (crista/piso) e ~0.4mm nas paredes
    n_ext   = max(8, ceil((aC0 + 360 - aC1) / 3));
    n_floor = max(8, ceil((aHf - aLf) / 3));
    n_w     = max(4, ceil((d_r - flat) / 0.4));

    // Laço único (CCW): corpo na crista → flanco inclinado desce → parede
    // radial até o piso → piso (arco na raiz) → parede radial sobe → flanco
    // inclinado sobe → fecha. As paredes radiais do piso seguem o padrão da
    // rosca quadrada (v0.8), que fecha malha sem slivers.
    secao_pts = concat(
        pts_arco(raio_crista, aC1, aC0 + 360, n_ext),
        pts_flank(raio_crista, aC0 + 360, rf, aLf + 360, n_w),
        [[rf * cos(aLf + 360), rf * sin(aLf + 360)],
         [raio_raiz * cos(aLf + 360), raio_raiz * sin(aLf + 360)]],
        pts_arco(raio_raiz, aLf + 360, aHf + 360, n_floor),
        [[raio_raiz * cos(aHf + 360), raio_raiz * sin(aHf + 360)],
         [rf * cos(aHf + 360), rf * sin(aHf + 360)]],
        pts_flank(rf, aHf + 360, raio_crista, aC1 + 360, n_w)
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

            // Lábio de batente: engrossa a borda superior do corpo no ombro
            // (z = comp_macho-labio_esp .. comp_macho). O tubo A encosta aqui
            // e trava a profundidade de colagem; anel fica flush com o tubo.
            if (labio_on)
                translate([0, 0, comp_macho - labio_esp])
                    anel(labio_od, od_peca - 0.4, labio_esp);

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
                // da rosca (costuram as camadas da espiga). Mesmo Ø do corpo
                // (v0.10); boss_centro foi movido p/ dentro p/ o boss não
                // invadir a raiz da rosca (Ø89/2=44.5).
                for (i = [0:parafuso_n - 1]) {
                    ang = i * 360 / parafuso_n;
                    rotate([0, 0, ang])
                        translate([boss_centro, 0, comp_macho - 0.01])
                            cylinder(d = boss_d,
                                     h = espiga_comp + 0.01,
                                     $fn = $fn_res);
                }
            }
            // TODO(baioneta): if (tipo_encaixe == "baioneta") { macho_baioneta(); }
        }

        // Furos dos tirantes atravessam corpo + espiga (até margem_topo do topo)
        tirantes_macho();

        // Chanfro de guia no topo da rosca (ponta da espiga)
        if (chanfro_on)
            chanfro_topo_espiga();
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

// Chanfro de guia 45° no TOPO da rosca do macho (ponta da espiga) — remove a
// aresta externa da ponta num cone de chanfro_rosca mm: a crista chega
// afunilada na entrada da fêmea, facilitando o encontro/inserção.
// Cutter = cilindro externo (R+ε) MENOS cone (R na base → R−s no topo) →
// sobra a cunha anelar 45° que é subtraída da ponta.
module chanfro_topo_espiga() {
    s      = chanfro_rosca;
    R      = rosca_od / 2;                // crista da rosca macho
    z_topo = comp_macho + espiga_comp;    // topo da espiga (120)
    translate([0, 0, z_topo - s])
        difference() {
            cylinder(d = 2 * R + 0.2, h = s + 0.2, $fn = $fn_res);
            cylinder(d1 = 2 * R, d2 = 2 * (R - s), h = s, $fn = $fn_res);
        }
}

// Chanfro de guia 45° na BOCA do recesso da fêmea (z=0, aresta INTERNA) —
// alarga a entrada (boca de sino) p/ o macho encontrar o furo com folga.
// Cutter = cone (Ø alargado na face → Ø da crista interna em chanfro_rosca).
module chanfro_boca_femea() {
    s     = chanfro_rosca;
    R_int = rosca_od / 2 + rosca_tol;   // crista da rosca INTERNA (fêmea)
    translate([0, 0, -0.05])
        cylinder(d1 = 2 * (R_int + s), d2 = 2 * R_int,
                 h = s + 0.05, $fn = $fn_res);
}

module femea() {
    if (tipo_encaixe == "rosca") {
        // Boca (base, virada p/ baixo) com rosca interna:
        // subtrai o mesmo cilindro rosqueado, alargado pela folga radial.
        // (o cilindro cobre o centro — o anel já é vazado no furo_interno)
        raio_crista_f = rosca_od / 2 + rosca_tol;   // crista interna: crista do macho + folga
        raio_raiz_f   = rosca_id / 2 + rosca_tol;   // raiz interna: raiz do macho + folga
        // (v0.9) raio_raiz_f era −tol (dente da fêmea alcançava DENTRO do raiz
        // do macho → par não rosqueava). Com +tol nos DOIS raios + flanco V,
        // a folga radial vira folga axial de flanco de ~0.5mm.
        difference() {
            union() {
                anel(od_peca, furo_interno, comp_femea);
                // Lábio de batente na boca do recesso (z=0..labio_esp): o
                // tubo B encosta aqui e trava a profundidade de colagem.
                if (labio_on)
                    anel(labio_od, od_peca - 0.4, labio_esp);
            }
            translate([0, 0, -0.01])
                cilindro_roscado(raio_crista_f, raio_raiz_f,
                                 recesso_prof, passo_rosca, larg_groove);
            // Prolongamento liso do furo no fundo (folga axial p/ ponta da
            // espiga — v0.9): Ø90 contínuo com a rosca, +fundo_extra de fundo
            translate([0, 0, recesso_prof - 0.01])
                cylinder(d = rosca_id + 2 * rosca_tol,
                         h = fundo_extra + 0.02, $fn = $fn_res);
            // Chanfro de guia na boca do recesso (z=0, aresta interna)
            if (chanfro_on)
                chanfro_boca_femea();
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
