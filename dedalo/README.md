# Dédalo — SR4-1000

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)

[← Voltar ao índice](../README.md)

## Sobre

O Dédalo é o quarto foguete da Serra Rocketry, projetado para atingir **1000 m de altitude** no **Latin American Space Challenge (LASC) 2026** — a maior competição aeroespacial da América Latina.

**Missão:** LASC 2026 — 1 km SRM (Mission ID 11, Tier 1)

## Nomenclatura

A designação segue o padrão interno da equipe:

```
SR<foguete>-<apogeu>
│  │         │
│  │         └── Apogeu esperado em metros
│  └──────────── Número do foguete (4º projeto)
└─────────────── Serra Rocketry
```

**Exemplo:** `SR4-1000` → 4º foguete, apogeu de 1000 m

## Especificações Estruturais

| Parâmetro | Valor |
|-----------|-------|
| Designação | SR4-1000 |
| Diâmetro interno | 100 mm |
| Diâmetro externo | 104 mm |
| Comprimento total | ~2400 mm |
| Peso estrutural | — |
| Material principal | Fibra de carbono |
| Motor | SRM (Solid Rocket Motor) |
| Tipo de recuperação | Ejeção por mola (paraquedas) |

## Arquitetura Modular

O foguete utiliza um **design modular** para agilizar a integração na área de lançamento e simplificar manutenções.

| Módulo | Função | Comprimento | Material |
|--------|--------|-------------|----------|
| 1 | Acomodar propulsor | 550 mm | Fibra de carbono |
| 2 | Eletrônica embarcada | 450 mm | Fibra de vidro |
| 3 | Sistema de recuperação | 600 mm | Fibra de carbono |
| 4 | Estabilidade durante voo | 300 mm | Fibra de carbono |
| 5 | Cone de nariz (redução de arrasto) | — | PETG |
| Tampa | Acesso ao sistema de recuperação | 500 mm | Fibra de carbono |

> O Módulo 2 utiliza fibra de vidro para permitir propagação de ondas de rádio (eletrônica embarcada).

## Estrutura do Projeto

```
dedalo/
├── docs/
│   ├── images/      → Renders e fotos do hardware
│   ├── DESIGN.md    → Decisões de design estrutural
│   └── CALCULOS.md  → Cálculos e FEA
├── hardware/
│   ├── cad/         → Modelos CAD (.FCStd, .step)
│   ├── 3d_models/   → STLs para impressão
│   └── README.md    → BOM, materiais, especificações
└── README.md        → Este arquivo
```

## Documentação

- [Decisões de Design](./docs/DESIGN.md)
- [Cálculos Estruturais](./docs/CALCULOS.md)
- [Hardware e Especificações](./hardware/README.md)

## Status

- [x] Definição de geometria
- [x] Seleção de materiais
- [ ] Modelos CAD
- [ ] Análise estrutural (FEA)
- [ ] Protótipo impresso
- [ ] Testes estruturais

## Autores

| Domínio | Membro |
|---------|--------|
| Aerodinâmica e Estruturas | [@PedroSerraRocketry](https://github.com/PedroSerraRocketry) |
