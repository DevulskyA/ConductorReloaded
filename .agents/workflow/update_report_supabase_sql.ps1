param(
    [string]$ReportPath = ".context/docs/RELATORIO_MUDANCAS_2026-02-07.md",
    [string]$RpcSqlPath = "backend/scripts/supabase_rpc_transfer_stock.sql",
    [string]$RlsSqlPath = "backend/scripts/supabase_rls_backend_only.sql"
)

$begin = "<!-- BEGIN:SUPABASE_SQL -->"
$end = "<!-- END:SUPABASE_SQL -->"

$report = Get-Content -Raw -Path $ReportPath
if ($report -notmatch [regex]::Escape($begin) -or $report -notmatch [regex]::Escape($end)) {
    throw "Markers not found in $ReportPath. Expected $begin and $end."
}

$lines = @()
$lines += "Abaixo esta o SQL exato aplicado no Supabase (mesmo conteudo dos arquivos do repo)."
$lines += ""

$lines += "#### $RpcSqlPath"
$lines += '```sql'
$lines += Get-Content -Path $RpcSqlPath
$lines += '```'
$lines += ""

$lines += "#### $RlsSqlPath"
$lines += '```sql'
$lines += Get-Content -Path $RlsSqlPath
$lines += '```'

$block = ($lines -join "`r`n")

$pattern = [regex]::Escape($begin) + ".*?" + [regex]::Escape($end)
$replacementLiteral = $begin + "`r`n" + $block + "`r`n" + $end

# IMPORTANT:
# Regex string replacements interpret '$$' as a single literal '$' (group substitution syntax),
# which would corrupt SQL blocks containing 'do $$' / 'as $$'. Use a MatchEvaluator to insert
# the replacement literally.
$updated = [regex]::Replace(
    $report,
    $pattern,
    { param($m) $replacementLiteral },
    [System.Text.RegularExpressions.RegexOptions]::Singleline
)

Set-Content -Path $ReportPath -Value $updated -NoNewline
Write-Host "Updated $ReportPath with Supabase SQL blocks."
