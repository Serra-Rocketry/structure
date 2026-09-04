# Cápsula do Altímetro (altimeter-egg)

[← Voltar ao índice](../README.md)

## Sobre

Cápsula protetora **elipsoidal** de duas peças para o altímetro **Jolly Logic AltimeterTwo** (14.5 × 18 × 49 mm, 9.9 g). O exterior era previsto em **ABS**; as peças reais impressas voaram em **TPU 95A**, que dissipa a energia do impacto e fecham por **rosca métrica** (gerada com `threads.scad`, apropriada para impressão 3D).

- **Status**: validado em voo (Thonyan, 500 m) — a cápsula TPU protegeu o altímetro numa queda balística; iterando o design (ver [Voo de validação](docs/DESIGN.md#voo-de-validação-thonyan-500-m))
- **Componente**: proteção de aviônicos (não pertence ao sistema de recuperação)

## Estrutura

```
altimeter-egg/
├── docs/
│   ├── DESIGN.md        # Decisões de design e parâmetros
│   └── images/          # Renders (corpo, tampa, montada, explodida, x-ray)
├── hardware/
│   ├── cad/             # altimeter-egg.scad (paramétrico) + threads.scad (CC0)
│   ├── 3d_models/       # .3mf para impressão (corpo e tampa)
│   └── README.md        # BOM, materiais, dimensões
└── README.md            # esta página
```

## Arquivos

| Arquivo | Descrição |
|---------|-----------|
| `hardware/cad/altimeter-egg.scad` | Modelo paramétrico (OpenSCAD), modos `corpo`/`tampa`/`assembled`/`split`/`xray` |
| `hardware/3d_models/altimeter-egg-corpo.3mf` | Corpo (metade + colar de rosca macho) |
| `hardware/3d_models/altimeter-egg-tampa.3mf` | Tampa (rosca interna / fêmea) |

## Recomendação de impressão

- **Filamento**: TPU 95A (absurdamente resistente ao impacto — ideal para pouso). Evitar 85A/muito mole para a rosca ter corpo.
- **Infill**: 40–60%
- **Posição**: as peças ficam dentro da mesa; usar brim se empenar
- **TPU na Ender 3 (Bowden)**: velocidade baixa (~25–30 mm/s), retração baixa ou desligada, hotend ~235–245 °C
- **Rosca em TPU**: o passo largo (3 mm) já ajuda bastante em material flexível. Se o encaixe "agarrar"/espanar no teste, aumentar `thl_clear` (0.35 → 0.5) ou dar mais voltas (`thl_len`). A rosca fêmea é a peça crítica — imprimir uma amostra antes.

## Licença

Modelo e documentação sob a licença do repositório (MIT). A biblioteca `threads.scad` é domínio público (CC0).
