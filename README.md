```markdown
# AXI4 Lite SystemVerilog Implementation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Базовая реализация протокола AXI4-Lite на SystemVerilog для изучения шинной архитектуры и верификации цифровых систем.

## Особенности

- Реализация Master и Slave устройств
- Отдельный testbench с примерами транзакций
- Конфигурируемые параметры шины
- Модульная архитектура
- Поддержка основных операций чтения/записи

## Структура проекта

```
axi4-lite-sv/
├── rtl/
│   ├── axi_interface.sv    // Интерфейс AXI4-Lite
│   ├── axi_master.sv       // Реализация Master устройства
│   └── axi_slave.sv        // Реализация Slave устройства
├── tb/
│   └── tb_axi.sv          // Testbench с тестовыми сценариями
├── includes/
│   ├── defines.sv         // Параметры конфигурации
│   └── typedefs.sv        // Пользовательские типы данных
└── README.md
```

## Требования

- Симулятор HDL (ModelSim/QuestaSim, VCS, Icarus Verilog)
- SystemVerilog поддержка (версия 2012 или новее)
- Python 3+ (для автоматизации тестов, опционально)

## Быстрый старт

### Компиляция и запуск (пример для ModelSim):

```bash
vlib work
vlog -sv ./includes/defines.sv ./includes/typedefs.sv \
      ./rtl/axi_interface.sv ./rtl/axi_master.sv \
      ./rtl/axi_slave.sv ./tb/tb_axi.sv
vsim work.tb_axi -novopt -do "run -all; quit"
```

### Пример вывода симуляции:
```
[INFO] Starting AXI4-Lite Testbench
[TEST] Basic Write Transaction: PASSED
[TEST] Basic Read Transaction: PASSED
[STAT] Simulation time: 150 ns
```

## Конфигурация

Изменение параметров шины (в `defines.sv`):
```systemverilog
`define AXI_ADDR_WIDTH 32  // Ширина адресной шины
`define AXI_DATA_WIDTH 32  // Ширина шины данных
`define AXI_ID_WIDTH   4   // Ширина идентификатора
```

## TODO

- [ ] Добавить поддержку burst-транзакций
- [ ] Реализовать арбитраж шины
- [ ] Добавить систему автоматических тестов
- [ ] Реализовать проверки (assertions)
- [ ] Добавить покрытие (coverage)
- [ ] Создать примеры использования с памятью

## Лицензия

Данный проект распространяется под лицензией MIT. Подробности см. в файле [LICENSE](LICENSE).

---

**Примечание**: Этот проект является учебной реализацией и требует дополнительной доработки для промышленного использования. Рекомендуется для:
- Изучения протокола AXI4
- Экспериментов с SystemVerilog
- Создания базовых тестовых окружений
- Разработки собственных верификационных компонентов
```
