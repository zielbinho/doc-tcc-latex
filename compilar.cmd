@echo off
rem Compila o TCC. Duplo clique ou, no terminal: compilar
rem Libera a execucao apenas deste script, sem alterar a politica do sistema.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0compilar.ps1" %*
