# Hardware — Cápsula do Altímetro (altimeter-egg)

[← Voltar ao índice](../README.md)

## Sobre

Cápsula protetora elipsoidal ("ovo") de duas peças para o altímetro **Jolly Logic AltimeterTwo**. Protege o sensor contra impacto no pouso: o exterior **TPU 95A** dissipa a energia, e a peça é fechada por rosca métrica.

## Lista de Materiais (BOM)

| Item | Qtd | Especificação | Material |
|------|-----|---------------|----------|
| Cápsula — Corpo (metade + colar de rosca) | 1 | Ø40 mm, comprimento 27 mm (colar) | TPU 95A |
| Cápsula — Tampa | 1 | Ø40 mm, rosca interna | TPU 95A |
| Altímetro (referência) | 1 | 14.5 × 18 × 49 mm, 9.9 g | — |

## Dimensões de Referência (da cápsula)

```
Elipsoide:      eixo maior 80 mm (X) × seção 70 mm (Y, Z)
Colar de rosca: raio 20 mm, passo 3 mm, comprimento 27 mm
Folga do encaixe: 0.35 mm
```

## Peças para Impressão 3D

| Peça | Arquivo | Material | Infill recomendado | Observações |
|------|---------|----------|--------------------|-------------|
| Corpo (macho) | `3d_models/altimeter-egg-corpo.3mf` | TPU 95A | 40–60% | Rosca externa métrica (threads.scad) |
| Tampa (fêmea) | `3d_models/altimeter-egg-tampa.3mf` | TPU 95A | 40–60% | Rosca interna |

> O modelo paramétrico está em `cad/altimeter-egg.scad`; roda no OpenSCAD e exporta o `.3mf`. A biblioteca de rosca usada é a `threads.scad` (domínio público / CC0).

## Como gerar os arquivos de impressão

```bash
# no diretório cad/
openscad -o corpo.3mf --render -D 'mode="corpo"'   altimeter-egg.scad
openscad -o tampa.3mf --render -D 'mode="tampa"'   altimeter-egg.scad
```

## Fonte

- Medidas do aparelho: manual do Jolly Logic AltimeterTwo (14.5 × 18 × 49 mm, 9.9 g).
