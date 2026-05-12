function Disconnect-T1 {
    Remove-Variable -Scope Script -Name _t1Uri -ErrorAction SilentlyContinue
    Remove-Variable -Scope Script -Name _t1Auth -ErrorAction SilentlyContinue
}
