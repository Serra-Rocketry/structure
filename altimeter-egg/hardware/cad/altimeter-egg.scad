// ============================================================================
// altimeter-egg.scad
// Cápsula elipsoidal ("ovo") para Jolly Logic AltimeterTwo — 2 peças.
//
// CONCEITO:
//   • CORPO (metade direita do ovo + COLAR de rosca): o colar, junto com a
//     metade do ovo, envolve todo o altímetro (49 mm, deitado em X). O colar
//     é um tubo com o FURO RETANGULAR do aparelho atravessando o centro.
//   • TAMPA (metade esquerda do ovo): fecha enroscando no colar (fêmea).
//
// ROSCA: biblioteca threads.scad (métrica, feita para impressão 3D).
//   macho = ScrewThread  |  fêmea = ScrewThread subtraído (porca)
//
// Elipsoide: eixo maior X = 8 cm alinhado ao comprimento do aparelho; seção 7 cm.
// ============================================================================

use <threads.scad>

mode = "split";   // "solid" | "filled" | "corpo" | "tampa" | "assembled" | "split" | "cutaway" | "xray"

// ---------- Elipsoide (ovo) ----------
L = 80;   // eixo maior (mm) = 8 cm
D = 70;   // seção (mm)     = 7 cm
sx = L/2; sy = D/2; sz = D/2;

// ---------- Altímetro (a REMOVER do interior — negativa) ----------
dev_l = 49.0;   // comprimento (eixo maior) — ao longo de X
dev_w = 14.5;   // largura — ao longo de Y
dev_h = 18.0;   // altura  — ao longo de Z
clearance = 1.0;// folga em volta do aparelho (mm)

// ---------- Furo de ventilação (ar / pressão) ----------
// Vent hole na ponta da TAMPA (eixo X, centro y=z=0): o AltimeterTwo mede
// pressão, precisa que o ar externo entre. O furo atravessa a parede da
// calota (x=-40 → -27) e abre na cavidade da rosca (interior da cápsula).
// Para mover a ponta do CORPO (x=+40), trocar o sinal de vent_x.
vent_d = 2.0;   // diâmetro do furo (mm)
vent_h = 16;    // comprimento do furo — atravessa a parede da ponta
vent_x = -(L/2); // ponta da tampa (x = -40)

// ---------- Separação / rotação das peças (só para a vista explodida) ----------
rot = 20;       // graus de rotação em torno de Z
sep = 45;       // afastamento entre as peças (mm, ao longo de X)

// ---------- Colar de rosca (macho) / fêmea (tampa) ----------
thl_r    = 20;  // raio da rosca (circunda o aparelho)
thl_len  = 27;  // comprimento do colar + profundidade da fêmea (cobre o aparelho)
thl_pitch= 3.0; // passo da rosca (LARGO — filetes espaçados, fácil de imprimir)
thl_clear= 0.35;// folga do encaixe macho/fêmea
thl_tooth= 25;  // ângulo do dente (menor = filete mais alto/grosso)

$fn = 120;

module ovo() scale([sx, sy, sz]) sphere(1, $fn=180);

// NEGATIVA: elipsoide menos a forma do altímetro
module ovo_vazado() difference() {
    ovo();
    cube([dev_l + clearance, dev_w + clearance, dev_h + clearance], center=true);
}

// ============================================================================
// COLAR MACHO com rosca — projeta para -X (a partir da face x=0 do corpo),
// com o furo retangular do aparelho atravessando o centro.
// ============================================================================
module macho() {
    dd = 2*thl_r;
    difference() {
        translate([-thl_len,0,0]) rotate([0,90,0])
            ScrewThread(outer_diam=dd, height=thl_len, pitch=thl_pitch,
                        tooth_angle=thl_tooth, tolerance=thl_clear);
        // furo retangular (passagem do aparelho) atravessando o colar inteiro
        translate([-thl_len/2,0,0])
            cube([thl_len+2, dev_w + clearance, dev_h + clearance], center=true);
    }
}

// ============================================================================
// GEOMETRIA (posição de montagem)
// ============================================================================
module corpo_geo() union() {
    intersection() {
        ovo_vazado();
        translate([0,-800,-800]) cube([800,1600,1600]);   // metade direita (x >= 0)
    }
    macho();                                               // colar projetando p/ -X
}

module tampa_geo() union() {
    difference() {
        // calota esquerda (a tampa) — MACIÇA (o aparelho fica no corpo+colar)
        intersection() {
            ovo();
            translate([-800,-800,-800]) cube([800,1600,1600]);
        }
        // rosca INTERNA (fêmea): subtrai o parafuso, um pouco maior p/ folga
        translate([-thl_len,0,0]) rotate([0,90,0])
            ScrewThread(outer_diam=2*thl_r + 2*thl_clear, height=thl_len,
                        pitch=thl_pitch, tooth_angle=thl_tooth, tolerance=thl_clear);
        // vent hole: furo de Øvent_d na ponta da tampa, ao longo do eixo X.
        // Atravessa a parede da calota e abre na cavidade da rosca (interior).
        translate([vent_x + vent_h/2 - 1, 0, 0]) rotate([0,90,0])
            cylinder(d=vent_d, h=vent_h, center=true);
    }
}

// ============================================================================
// DESENHO TÉCNICO (2D): meia-seção longitudinal + cotas → export SVG/PNG
// ============================================================================
module seta(x1, y1, x2, y2) {   // leader line com bolinha na ponta (na peça)
    hull() {
        translate([x1, y1]) circle(d=0.8, $fn=8);
        translate([x2, y2]) circle(d=0.25, $fn=8);
    }
    translate([x1, y1]) circle(d=0.9, $fn=10);
}
module label_at(x, y, s, ha="left", va="baseline")
    translate([x, y]) text(s, size=4.5, halign=ha, valign=va);

module techdraw() {
    // seção longitudinal: projection corta em y=0; NÃO usar cubo de recorte
    // (face coplanar com o plano de corte degenera o CGAL no projection)
    projection(cut=true)
        rotate([90, 0, 0])
        union() { corpo_geo(); tampa_geo(); }

    // cotas (2D: X horizontal, Y = -Z vertical)
    seta( 40,  0,  51,  0);   label_at(51,  0, "L = 80", "left");
    seta(  0,-35,  -2,-46);   label_at(-2,-46, "Ø 70 (seção do ovo)", "right");
    seta(  0,-20,  10,-33);   label_at(10,-33, "Ø 40 (rosca)", "left");
    seta(-13.5, 0, -13.5, 14);label_at(-13.5, 15, "rosca = 27", "center");
    seta(-40,  0, -53,  2);   label_at(-53,  2, "vent Ø 2", "right");
    seta(-33.5,-14, -44,-22); label_at(-44,-22, "parede tampa ≈ 13", "right");
}

// ============================================================================
// Render
// ============================================================================
if (mode == "solid")       color("#3d3d3d") ovo();
else if (mode == "filled") color("#3d3d3d") ovo_vazado();
else if (mode == "corpo")  corpo_geo();
else if (mode == "tampa")  tampa_geo();
else if (mode == "assembled") {
    color("#333333") corpo_geo();
    color("#dddddd") tampa_geo();
}
else if (mode == "xray") {
    // transparência (ver com F5 no OpenSCAD; CGAL/export ignora alpha)
    color("#333333", 0.35) corpo_geo();
    color("#dddddd", 0.35) tampa_geo();
}
else if (mode == "split") {
    color("#333333") translate([ sep/2,0,0]) rotate([0,0, rot]) corpo_geo();
    color("#dddddd") translate([-sep/2,0,0]) rotate([0,0,-rot]) tampa_geo();
}
else if (mode == "cutaway") {
    intersection() {
        union() { color("#333333") corpo_geo(); color("#dddddd") tampa_geo(); }
        translate([-999,-999,-1]) cube([999,1998,2000]);
    }
}
else if (mode == "ventcut") {
    // corte no plano y=0 (passa pelo eixo do vent hole) — mostra o túnel
    intersection() {
        union() { color("#333333") corpo_geo(); color("#dddddd") tampa_geo(); }
        translate([-999,-999,-1]) cube([1998,1000,2000]);
    }
}
else if (mode == "techdraw") techdraw();
