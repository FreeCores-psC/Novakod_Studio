component CConsole(
    in  active ubyte iWebConsole,
    out active ubyte oWebConsole)
{
    DoSomething(0) on iWebConsole
    {
        oWebConsole := iWebConsole;
    }
};