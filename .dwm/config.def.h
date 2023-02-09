/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 7;        /* border pixel of windows */
static const unsigned int igappx    = 5;        /* size of inner gaps */
static const unsigned int ogappx    = 5;        /* size of outer gaps */
static const int gapsforone	        = 0;	    /* 1 enable gaps when only one window is open */
static const unsigned int snap      = 32;       /* snap pixel */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char * fonts[]          = { "mononoki:size=12" };
static const char dmenufont[]       = "mononoki:size=12";
static const char col_norm_border[]      = "#733543";
static const char col_norm_foreground[]  = "#FFFFED";
static const char col_norm_background[]  = "#853530";
static const char col_sel_border[]      = "#B8546C";
static const char col_sel_foreground[]  = "#FFFFED";
static const char col_sel_background[]  = "#C44F47";
static const char * colors[][3]      =
{
	/*               fg         bg         border   */
	[SchemeNorm] = { col_norm_foreground, col_norm_background,  col_norm_border},
	[SchemeSel]  = { col_sel_foreground, col_sel_background,  col_sel_border},
};

/* tagging */
static const char * tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] =
{
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                     instance  title           tags mask    isfloating  isterminal  noswallow  monitor */
	{ "Emacs",                   NULL,     NULL,           1 << 1,         0,          0,           0,        -1 },
	{ "google-chat-electron",    NULL,     NULL,           1 << 6,         0,          0,           0,        -1 },
	{ "Google-chrome",           NULL,     NULL,           1 << 8,         0,          0,           0,        -1 },
};

/* layout(s) */
static const int dirs[3]      = { DirHor, DirVer, DirVer }; /* tiling dirs */
static const float facts[3]   = { 1.1,    1.1,    1.1 };    /* tiling facts */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] =
{
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
#define TILEKEYS(MOD,G,M,S) \
	{ MOD, XK_r, setdirs,  {.v = (int[])  { INC(G * +1),   INC(M * +1),   INC(S * +1) } } }, \
	{ MOD, XK_h, setfacts, {.v = (float[]){ INC(G * -0.1), INC(M * -0.1), INC(S * -0.1) } } }, \
	{ MOD, XK_l, setfacts, {.v = (float[]){ INC(G * +0.1), INC(M * +0.1), INC(S * +0.1) } } },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char * dmenucmd[] = { "rofi", "-show", "run", "-theme", "pinky", NULL };
static const char * termcmd[]  = { "alacritty", NULL };
static const char * rofisshcmd[]  = { "rofi", "-show", "ssh", "-theme", "pinky", NULL };

static Key keys[] =
{
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_s,      spawn,          {.v = rofisshcmd } },
	{ MODKEY | ShiftMask,           XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY | ShiftMask,           XK_c,      killclient,     {0} },
	{ MODKEY | ShiftMask,             XK_i,      setigaps,       {.i = +2 } },
	{ MODKEY | ControlMask,           XK_i,      setigaps,       {.i = -2 } },
	{ MODKEY | ShiftMask | ControlMask, XK_i,      setigaps,       {.i = 0  } },
	{ MODKEY | ShiftMask,             XK_o,      setogaps,       {.i = +2 } },
	{ MODKEY | ControlMask,           XK_o,      setogaps,       {.i = -2 } },
	{ MODKEY | ShiftMask | ControlMask, XK_o,      setogaps,       {.i = 0  } },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	TILEKEYS(MODKEY,                                           1, 0, 0)
	TILEKEYS(MODKEY | ShiftMask,                                 0, 1, 0)
	TILEKEYS(MODKEY | ControlMask,                               0, 0, 1)
	TILEKEYS(MODKEY | ShiftMask | ControlMask,                     1, 1, 1)
	{
		MODKEY | ShiftMask,             XK_t,      setdirs,
		{
			.v = (int[])
			{
				DirHor, DirVer, DirVer
			}
		}
	},
	{
		MODKEY | ControlMask,           XK_t,      setdirs,        {
			.v = (int[])
			{
				DirVer, DirHor, DirHor
			}
		}
	},
	{ MODKEY | ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY | ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY | ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY | ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(XK_1,                      0)
	TAGKEYS(XK_2,                      1)
	TAGKEYS(XK_3,                      2)
	TAGKEYS(XK_4,                      3)
	TAGKEYS(XK_5,                      4)
	TAGKEYS(XK_6,                      5)
	TAGKEYS(XK_7,                      6)
	TAGKEYS(XK_8,                      7)
	TAGKEYS(XK_9,                      8)
	{
		MODKEY | ShiftMask,             XK_q,      quit,           {0}
	},
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] =
{
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
