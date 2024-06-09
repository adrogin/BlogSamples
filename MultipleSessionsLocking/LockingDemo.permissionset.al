permissionset 50700 LockingDemo
{
    Assignable = true;
    Permissions = tabledata "Locking Session Event" = RIMD,
        tabledata "Locking Test" = RIMD,
        tabledata "Session Parameters" = RIMD,
        table "Locking Session Event" = X,
        table "Locking Test" = X,
        table "Session Parameters" = X,
        codeunit "Locking Action" = X,
        codeunit "Locking Mgt." = X,
        codeunit "Locking Session Controller" = X,
        page "Locking Session Events" = X,
        page "Locking Test" = X;
}