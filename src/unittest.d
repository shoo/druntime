/**
 * Unit tests for the D runtime.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2010.
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Sean Kelly
 */

/*          Copyright Sean Kelly 2005 - 2010.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
version (dll_test001)
{
    import core.sys.windows.windows;
    import core.sys.windows.dll;
    
    __gshared HINSTANCE g_hInst;
    
    extern (Windows)
    BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
    {
        switch (ulReason)
        {
        case DLL_PROCESS_ATTACH:
            g_hInst = hInstance;
            dll_process_attach( hInstance, true );
            break;
        
        case DLL_PROCESS_DETACH:
            dll_process_detach( hInstance, true );
            break;
        
        case DLL_THREAD_ATTACH:
            dll_thread_attach( true, true );
            break;
        
        case DLL_THREAD_DETACH:
            dll_thread_detach( true, true );
            break;
        default:
            break;
        }
        return true;
    }
    extern (C) int foo(int a)
    {
        return a+1;
    }
}
else version (dll_test002)
{
    import core.runtime;
    import core.sys.windows.windows;
    import core.stdc.stdio, core.stdc.wchar_;
    alias extern (C) int function(int) FooProc;
    void main()
    {
        auto mod = Runtime.loadLibrary("dlltest.dll");
        assert(mod);
        auto foo = cast(FooProc)GetProcAddress(mod, "foo");
        assert(foo);
        assert(foo(1) == 2);
        Runtime.unloadLibrary(mod);
        enum dirnames = ["ルイズ！ルイズ！ルイズ！ルイズぅぅうううわぁああああああああああああああああああああああん！！！"
                       , "あぁああああ…ああ…あっあっー！あぁああああああ！！！ルイズルイズルイズぅううぁわぁああああ！！！"
                       , "あぁクンカクンカ！クンカクンカ！スーハースーハー！スーハースーハー！いい匂いだなぁ…くんくん"
                       , "んはぁっ！ルイズ・フランソワーズたんの桃色ブロンドの髪をクンカクンカしたいお！クンカクンカ！あぁあ！！"
                       , "間違えた！モフモフしたいお！モフモフ！モフモフ！髪髪モフモフ！カリカリモフモフ…きゅんきゅんきゅい！！"
                       , "小説12巻のルイズたんかわいかったよぅ！！あぁぁああ…あああ…あっあぁああああ！！ふぁぁあああんんっ！！"
                       , "アニメ2期放送されて良かったねルイズたん！あぁあああああ！かわいい！ルイズたん！かわいい！あっああぁああ！"
                       , "コミック2巻も発売されて嬉し…いやぁああああああ！！！にゃああああああああん！！ぎゃああああああああ！！"
                       , "ぐあああああああああああ！！！コミックなんて現実じゃない！！！！あ…小説もアニメもよく考えたら…"
                       , "ル イ ズ ち ゃ ん は 現実 じ ゃ な い？にゃあああああああああああああん！！うぁああああああああああ！！"
                       , "そんなぁああああああ！！いやぁぁぁあああああああああ！！はぁああああああん！！ハルケギニアぁああああ！！"
                       , "この！ちきしょー！やめてやる！！現実なんかやめ…て…え！？見…てる？表紙絵のルイズちゃんが僕を見てる？"
                       , "表紙絵のルイズちゃんが僕を見てるぞ！ルイズちゃんが僕を見てるぞ！挿絵のルイズちゃんが僕を見てるぞ！！"
                       , "アニメのルイズちゃんが僕に話しかけてるぞ！！！よかった…世の中まだまだ捨てたモンじゃないんだねっ！"
                       , "いやっほぉおおおおおおお！！！僕にはルイズちゃんがいる！！やったよケティ！！ひとりでできるもん！！！"
                       , "あ、コミックのルイズちゃああああああああああああああん！！いやぁあああああああああああああああ！！！！"
                       , "あっあんああっああんあアン様ぁあ！！シ、シエスター！！アンリエッタぁああああああ！！！タバサｧぁあああ！！"
                       , "ううっうぅうう！！俺の想いよルイズへ届け！！ハルケギニアのルイズへ届け！"];
        auto dirname = r"\\?\";
        wchar[500] wcurdirbuf;
        auto wcurdirbuflen = GetCurrentDirectoryW(wcurdirbuf.length, wcurdirbuf.ptr);
        foreach (char c; wcurdirbuf[0..wcurdirbuflen]) dirname ~= c;
        
        immutable(wchar)*[] dirs;
        foreach (dn; dirnames)
        {
            dirname ~= "\\" ~ dn;
            wstring wdirname;
            foreach (wchar c; dirname)
            {
                wdirname ~= c;
            }
            auto wdir = (wdirname ~ "\0").ptr;
            dirs = wdir ~ dirs;
            CreateDirectoryW(wdir, null);
        }
        scope (exit) foreach (d; dirs)
        {
            RemoveDirectoryW(d);
        }
        auto filename = dirname ~ "\\逝ってしまったわ、円環の理に導かれて・・・.dll";
        wstring wfilename;
        foreach (wchar c; filename)
        {
            wfilename ~= c;
        }
        immutable(wchar)* wpfilepath = (wfilename ~ "\0"w).ptr;
        auto res = MoveFileW(r"dlltest.dll"w.ptr, wpfilepath);
        scope (exit)
        {
            DeleteFileW(wpfilepath);
        }
        
        mod = Runtime.loadLibrary(filename);
        foo = cast(FooProc)GetProcAddress(mod, "foo");
        assert(foo(2) == 3);
        Runtime.unloadLibrary(mod);
    }
}
else:

public import core.atomic;
public import core.bitop;
public import core.cpuid;
public import core.demangle;
public import core.exception;
public import core.memory;
public import core.runtime;
public import core.thread;
public import core.vararg;

public import core.sync.condition;
public import core.sync.mutex;
public import core.sync.rwmutex;
public import core.sync.semaphore;

version(posix)
    public import core.sys.posix.sys.select;

void main()
{
    // Bring in unit test for module by referencing a function in it
    shared(int) i;
    cas( &i, 0, 1 ); // atomic
    auto b = bsf( 0 ); // bitop
    mmx(); // cpuid
    demangle( "" ); // demangle
    setAssertHandler( null ); // exception
    // SES - disabled because you cannot enable the GC without disabling it.
    //GC.enable(); // memory
    Runtime.collectHandler = null; // runtime
    static void fn() {}
    new Thread( &fn ); // thread
    va_end( null ); // vararg

    auto m = new Mutex; // mutex
    auto c = new Condition( m ); // condition
    auto r = new ReadWriteMutex; // rwmutex
    auto s = new Semaphore; // semaphore
}
