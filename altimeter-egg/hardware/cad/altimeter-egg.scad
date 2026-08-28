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
    }
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
