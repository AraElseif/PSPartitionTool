@{
    RootModule              ='PSPartitionTool.psm1'
    ModuleVersion           ='0.1.0'
    GUID                    ='cceb1c0c-3309-47f0-8bee-6d9a72743a75'
    Author                  ='AraElseif'
    PowerShellVersion       ='5.1'
    CompatiblePSEditions    =@('Desktop', 'Core')
    Description             ='Powershell module for disk partitioning.'
    FunctionsToExport       =@(
        'New-PartitionDisk'
    )
    RequiredModules         =@()
}