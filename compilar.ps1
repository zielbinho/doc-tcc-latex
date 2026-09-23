# Compila o TCC: pdflatex -> bibtex -> pdflatex -> pdflatex
# Uso (no PowerShell, dentro desta pasta):  .\compilar.ps1
$env:PATH = "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64;$env:PATH"
Set-Location $PSScriptRoot

function Run-Pdflatex {
    pdflatex -interaction=nonstopmode -halt-on-error tcc.tex *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro no pdflatex. Trecho do tcc.log:" -ForegroundColor Red
        Get-Content tcc.log | Select-String -Pattern '^!' -Context 0, 6 | Select-Object -First 3
        exit 1
    }
}

Run-Pdflatex
bibtex tcc *> $null
$blgErrors = Select-String -Path tcc.blg -Pattern 'error message'
if ($blgErrors) { Write-Host "BibTeX: $($blgErrors.Line) (veja tcc.blg)" -ForegroundColor Yellow }
Run-Pdflatex
Run-Pdflatex

$todos = (Select-String -Path *.tex -Pattern '\\todo\{' -Exclude tcc.tex).Count
$undef = Select-String -Path tcc.log -Pattern 'undefined' | Where-Object { $_.Line -match 'Reference|Citation' }
Write-Host "tcc.pdf gerado. Pendencias [TODO] no texto: $todos" -ForegroundColor Green
if ($undef) { Write-Host "Referencias/citacoes indefinidas:" -ForegroundColor Yellow; $undef | ForEach-Object { $_.Line } }
