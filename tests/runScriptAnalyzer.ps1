$result = Invoke-ScriptAnalyzer -Path "..\src\Dynamics365Configuration" -Recurse -ExcludeRule PSUseApprovedVerbs, PSUseDeclaredVarsMoreThanAssignments, PSAvoidUsingWMICmdlet, PSUseSingularNouns
$result
if ( $result ) {
    throw "Version is not determined";
}
