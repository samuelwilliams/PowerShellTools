Function Generate-Password {
    param(
        $Length = 16
    )

    $chars = "!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".ToCharArray()
    $returnVal = ''
    for ($i=0;$i -lt $Length; $i++) {
        $returnVal += ($chars | sort {Get-Random})[0]
    }

    return $returnVal
}