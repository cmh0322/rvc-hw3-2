#ifdef PEG
struct T_SRC {
	char *fl; int ln;
} T_SRC[NTRANS];

void
tr_2_src(int m, char *file, int ln)
{	T_SRC[m].fl = file;
	T_SRC[m].ln = ln;
}

void
putpeg(int n, int m)
{	printf("%5d	trans %4d ", m, n);
	printf("%s:%d\n",
		T_SRC[n].fl, T_SRC[n].ln);
}
#endif

void
settable(void)
{	Trans *T;
	Trans *settr(int, int, int, int, int, char *, int, int, int);

	trans = (Trans ***) emalloc(2*sizeof(Trans **));

	/* proctype 0: Controller */

	trans[0] = (Trans **) emalloc(243*sizeof(Trans *));

	T = trans[ 0][37] = settr(36,2,0,0,0,"ATOMIC", 1, 2, 0);
	T->nxt	= settr(36,2,1,0,0,"ATOMIC", 1, 2, 0);
	trans[0][1]	= settr(0,2,35,3,3,"state = Forward", 1, 2, 0); /* m: 2 -> 0,35 */
	reached0[2] = 1;
	trans[0][2]	= settr(0,0,0,0,0,"previous = Forward",0,0,0);
	trans[0][3]	= settr(0,0,0,0,0,"assert(((state==Forward)&&(elapsed==6)))",0,0,0);
	trans[0][4]	= settr(0,0,0,0,0,"assert(((command==NoCommand)&&(direction==NoCommand)))",0,0,0);
	trans[0][5]	= settr(0,0,0,0,0,"assert(((!(clean_emitted)&&!(start_timer))&&(emitted==0)))",0,0,0);
	trans[0][6]	= settr(0,0,0,0,0,"printf('INIT T0 state=%e command=%e elapsed=%d\\n',state,command,elapsed)",0,0,0);
	trans[0][7]	= settr(0,0,0,0,0,"assert((transition!=255))",0,0,0);
	trans[0][8]	= settr(0,0,0,0,0,"assert((state!=0))",0,0,0);
	T = trans[ 0][35] = settr(34,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(34,0,9,0,0,"sub-sequence", 1, 2, 0);
	trans[0][9]	= settr(8,2,17,4,4,"sampled = 0", 1, 2, 0);
	T = trans[0][17] = settr(16,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(16,2,10,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(16,2,12,0,0,"IF", 1, 2, 0);
	trans[0][10]	= settr(9,2,22,5,5,"((1&&(state==Stopping)))", 1, 2, 0); /* m: 11 -> 22,0 */
	reached0[11] = 1;
	trans[0][11]	= settr(0,0,0,0,0,"front = 1",0,0,0);
	trans[0][18]	= settr(17,2,19,1,0,".(goto)", 1, 2, 0); /* m: 19 -> 0,22 */
	reached0[19] = 1;
	trans[0][12]	= settr(11,2,15,6,0,"(!((1&&(state==Stopping))))", 1, 2, 0);
	T = trans[0][15] = settr(14,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(14,2,13,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(14,2,14,0,0,"IF", 1, 2, 0);
	trans[0][13]	= settr(12,2,22,7,7,"front = 0", 1, 2, 0); /* m: 19 -> 0,22 */
	reached0[19] = 1;
	trans[0][16]	= settr(15,2,19,1,0,".(goto)", 1, 2, 0); /* m: 19 -> 0,22 */
	reached0[19] = 1;
	trans[0][14]	= settr(13,2,22,8,8,"front = 1", 1, 2, 0); /* m: 19 -> 0,22 */
	reached0[19] = 1;
	trans[0][19]	= settr(18,2,22,9,9,"sampled = (sampled|1)", 1, 2, 0);
	T = trans[0][22] = settr(21,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(21,2,20,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(21,2,21,0,0,"IF", 1, 2, 0);
	trans[0][20]	= settr(19,2,27,10,10,"left = 0", 1, 2, 0); /* m: 24 -> 0,27 */
	reached0[24] = 1;
	trans[0][23]	= settr(22,2,24,1,0,".(goto)", 1, 2, 0); /* m: 24 -> 0,27 */
	reached0[24] = 1;
	trans[0][21]	= settr(20,2,27,11,11,"left = 1", 1, 2, 0); /* m: 24 -> 0,27 */
	reached0[24] = 1;
	trans[0][24]	= settr(23,2,27,12,12,"sampled = (sampled|2)", 1, 2, 0);
	T = trans[0][27] = settr(26,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(26,2,25,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(26,2,26,0,0,"IF", 1, 2, 0);
	trans[0][25]	= settr(24,2,32,13,13,"right = 0", 1, 2, 0); /* m: 29 -> 0,32 */
	reached0[29] = 1;
	trans[0][28]	= settr(27,2,29,1,0,".(goto)", 1, 2, 0); /* m: 29 -> 0,32 */
	reached0[29] = 1;
	trans[0][26]	= settr(25,2,32,14,14,"right = 1", 1, 2, 0); /* m: 29 -> 0,32 */
	reached0[29] = 1;
	trans[0][29]	= settr(28,2,32,15,15,"sampled = (sampled|4)", 1, 2, 0);
	T = trans[0][32] = settr(31,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(31,2,30,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(31,2,31,0,0,"IF", 1, 2, 0);
	trans[0][30]	= settr(29,0,239,16,16,"dust = 0", 1, 2, 0); /* m: 34 -> 0,239 */
	reached0[34] = 1;
	trans[0][33]	= settr(32,2,34,1,0,".(goto)", 1, 2, 0); /* m: 34 -> 0,239 */
	reached0[34] = 1;
	trans[0][31]	= settr(30,0,239,17,17,"dust = 1", 1, 2, 0); /* m: 34 -> 0,239 */
	reached0[34] = 1;
	trans[0][34]	= settr(33,0,239,18,18,"sampled = (sampled|8)", 1, 2, 0); /* m: 36 -> 0,239 */
	reached0[36] = 1;
	trans[0][36]	= settr(0,0,0,0,0,"assert((sampled==15))",0,0,0);
	trans[0][240]	= settr(239,0,239,1,0,".(goto)", 0, 2, 0);
	T = trans[0][239] = settr(238,0,0,0,0,"DO", 0, 2, 0);
	    T->nxt	= settr(238,0,238,0,0,"DO", 0, 2, 0);
	T = trans[ 0][238] = settr(237,2,0,0,0,"ATOMIC", 1, 2, 0);
	T->nxt	= settr(237,2,38,0,0,"ATOMIC", 1, 2, 0);
	trans[0][38]	= settr(37,2,69,19,19,"stable = 0", 1, 2, 0);
	T = trans[0][69] = settr(68,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(68,2,39,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(68,2,41,0,0,"IF", 1, 2, 0);
	trans[0][39]	= settr(38,2,82,20,20,"(first_tick)", 1, 2, 0); /* m: 40 -> 82,0 */
	reached0[40] = 1;
	trans[0][40]	= settr(0,0,0,0,0,"first_tick = 0",0,0,0);
	trans[0][70]	= settr(69,2,71,1,0,".(goto)", 1, 2, 0); /* m: 71 -> 0,82 */
	reached0[71] = 1;
	trans[0][41]	= settr(40,2,68,2,0,"else", 1, 2, 0);
	T = trans[ 0][68] = settr(67,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(67,0,42,0,0,"sub-sequence", 1, 2, 0);
	trans[0][42]	= settr(41,2,50,21,21,"sampled = 0", 1, 2, 0);
	T = trans[0][50] = settr(49,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(49,2,43,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(49,2,45,0,0,"IF", 1, 2, 0);
	trans[0][43]	= settr(42,2,55,22,22,"((1&&(state==Stopping)))", 1, 2, 0); /* m: 44 -> 55,0 */
	reached0[44] = 1;
	trans[0][44]	= settr(0,0,0,0,0,"front = 1",0,0,0);
	trans[0][51]	= settr(50,2,52,1,0,".(goto)", 1, 2, 0); /* m: 52 -> 0,55 */
	reached0[52] = 1;
	trans[0][45]	= settr(44,2,48,23,0,"(!((1&&(state==Stopping))))", 1, 2, 0);
	T = trans[0][48] = settr(47,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(47,2,46,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(47,2,47,0,0,"IF", 1, 2, 0);
	trans[0][46]	= settr(45,2,55,24,24,"front = 0", 1, 2, 0); /* m: 52 -> 0,55 */
	reached0[52] = 1;
	trans[0][49]	= settr(48,2,52,1,0,".(goto)", 1, 2, 0); /* m: 52 -> 0,55 */
	reached0[52] = 1;
	trans[0][47]	= settr(46,2,55,25,25,"front = 1", 1, 2, 0); /* m: 52 -> 0,55 */
	reached0[52] = 1;
	trans[0][52]	= settr(51,2,55,26,26,"sampled = (sampled|1)", 1, 2, 0);
	T = trans[0][55] = settr(54,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(54,2,53,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(54,2,54,0,0,"IF", 1, 2, 0);
	trans[0][53]	= settr(52,2,60,27,27,"left = 0", 1, 2, 0); /* m: 57 -> 0,60 */
	reached0[57] = 1;
	trans[0][56]	= settr(55,2,57,1,0,".(goto)", 1, 2, 0); /* m: 57 -> 0,60 */
	reached0[57] = 1;
	trans[0][54]	= settr(53,2,60,28,28,"left = 1", 1, 2, 0); /* m: 57 -> 0,60 */
	reached0[57] = 1;
	trans[0][57]	= settr(56,2,60,29,29,"sampled = (sampled|2)", 1, 2, 0);
	T = trans[0][60] = settr(59,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(59,2,58,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(59,2,59,0,0,"IF", 1, 2, 0);
	trans[0][58]	= settr(57,2,65,30,30,"right = 0", 1, 2, 0); /* m: 62 -> 0,65 */
	reached0[62] = 1;
	trans[0][61]	= settr(60,2,62,1,0,".(goto)", 1, 2, 0); /* m: 62 -> 0,65 */
	reached0[62] = 1;
	trans[0][59]	= settr(58,2,65,31,31,"right = 1", 1, 2, 0); /* m: 62 -> 0,65 */
	reached0[62] = 1;
	trans[0][62]	= settr(61,2,65,32,32,"sampled = (sampled|4)", 1, 2, 0);
	T = trans[0][65] = settr(64,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(64,2,63,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(64,2,64,0,0,"IF", 1, 2, 0);
	trans[0][63]	= settr(62,2,82,33,33,"dust = 0", 1, 2, 0); /* m: 67 -> 0,82 */
	reached0[67] = 1;
	trans[0][66]	= settr(65,2,67,1,0,".(goto)", 1, 2, 0); /* m: 67 -> 0,82 */
	reached0[67] = 1;
	trans[0][64]	= settr(63,2,82,34,34,"dust = 1", 1, 2, 0); /* m: 67 -> 0,82 */
	reached0[67] = 1;
	trans[0][67]	= settr(66,2,82,35,35,"sampled = (sampled|8)", 1, 2, 0); /* m: 71 -> 0,82 */
	reached0[71] = 1;
	trans[0][71]	= settr(70,2,82,36,36,"assert((sampled==15))", 1, 2, 0); /* m: 72 -> 0,82 */
	reached0[72] = 1;
	trans[0][72]	= settr(0,0,0,0,0,"previous = state",0,0,0);
	trans[0][73]	= settr(0,0,0,0,0,"emitted = 0",0,0,0);
	trans[0][74]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][75]	= settr(0,0,0,0,0,"done = 0",0,0,0);
	T = trans[0][82] = settr(81,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(81,2,76,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(81,2,78,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(81,2,80,0,0,"IF", 1, 2, 0);
	trans[0][76]	= settr(75,2,91,37,37,"(!(right))", 1, 2, 0); /* m: 77 -> 91,0 */
	reached0[77] = 1;
	trans[0][77]	= settr(0,0,0,0,0,"side = RightOpen",0,0,0);
	trans[0][83]	= settr(82,2,84,1,0,".(goto)", 1, 2, 0); /* m: 84 -> 0,91 */
	reached0[84] = 1;
	trans[0][78]	= settr(77,2,91,38,38,"((right&&!(left)))", 1, 2, 0); /* m: 79 -> 91,0 */
	reached0[79] = 1;
	trans[0][79]	= settr(0,0,0,0,0,"side = LeftOpen",0,0,0);
	trans[0][80]	= settr(79,2,91,39,39,"((right&&left))", 1, 2, 0); /* m: 81 -> 91,0 */
	reached0[81] = 1;
	trans[0][81]	= settr(0,0,0,0,0,"side = SidesBlocked",0,0,0);
	trans[0][84]	= settr(83,2,91,40,40,"assert(((side==RightOpen)==!(right)))", 1, 2, 0); /* m: 85 -> 0,91 */
	reached0[85] = 1;
	trans[0][85]	= settr(0,0,0,0,0,"assert(((side==LeftOpen)==(right&&!(left))))",0,0,0);
	trans[0][86]	= settr(0,0,0,0,0,"assert(((side==SidesBlocked)==(right&&left)))",0,0,0);
	T = trans[0][91] = settr(90,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(90,2,87,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(90,2,89,0,0,"IF", 1, 2, 0);
	trans[0][87]	= settr(86,2,104,41,41,"((remaining>0))", 1, 2, 0); /* m: 88 -> 104,0 */
	reached0[88] = 1;
	trans[0][88]	= settr(0,0,0,0,0,"remaining = (remaining-1)",0,0,0);
	trans[0][92]	= settr(91,2,104,1,0,".(goto)", 1, 2, 0);
	trans[0][89]	= settr(88,2,90,2,0,"else", 1, 2, 0);
	trans[0][90]	= settr(89,2,104,1,0,"(1)", 1, 2, 0);
	T = trans[0][104] = settr(103,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(103,2,93,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(103,2,102,0,0,"IF", 1, 2, 0);
	trans[0][93]	= settr(92,2,100,42,42,"((elapsed!=6))", 1, 2, 0); /* m: 94 -> 100,0 */
	reached0[94] = 1;
	trans[0][94]	= settr(0,0,0,0,0,"elapsed = (elapsed+1)",0,0,0);
	T = trans[0][100] = settr(99,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(99,2,95,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(99,2,98,0,0,"IF", 1, 2, 0);
	trans[0][95]	= settr(94,2,207,43,43,"((elapsed==5))", 1, 2, 0); /* m: 96 -> 207,0 */
	reached0[96] = 1;
	trans[0][96]	= settr(0,0,0,0,0,"done = 1",0,0,0);
	trans[0][97]	= settr(0,0,0,0,0,"elapsed = 6",0,0,0);
	trans[0][101]	= settr(100,2,106,1,0,".(goto)", 1, 2, 0); /* m: 106 -> 0,207 */
	reached0[106] = 1;
	trans[0][98]	= settr(97,2,99,2,0,"else", 1, 2, 0);
	trans[0][99]	= settr(98,2,207,44,44,"(1)", 1, 2, 0); /* m: 106 -> 207,0 */
	reached0[106] = 1;
	trans[0][105]	= settr(104,2,106,1,0,".(goto)", 1, 2, 0); /* m: 106 -> 0,207 */
	reached0[106] = 1;
	trans[0][102]	= settr(101,2,103,2,0,"else", 1, 2, 0);
	trans[0][103]	= settr(102,2,207,45,45,"(1)", 1, 2, 0); /* m: 106 -> 207,0 */
	reached0[106] = 1;
	trans[0][106]	= settr(105,2,207,46,46,"assert((done==((previous!=Forward)&&(remaining==0))))", 1, 2, 0); /* m: 107 -> 0,207 */
	reached0[107] = 1;
	trans[0][107]	= settr(0,0,0,0,0,"guards = (((((((((((((((previous==Forward)&&!(front))+((previous==Forward)&&front))+((previous==Stopping)&&!(done)))+(((previous==Stopping)&&done)&&(side==RightOpen)))+(((previous==Stopping)&&done)&&(side==LeftOpen)))+(((previous==Stopping)&&done)&&(side==SidesBlocked)))+((previous==Backing)&&!(done)))+(((previous==Backing)&&done)&&(side==SidesBlocked)))+(((previous==Backing)&&done)&&(side==RightOpen)))+(((previous==Backing)&&done)&&(side==LeftOpen)))+((previous==TurningRight)&&!(done)))+((previous==TurningRight)&&done))+((previous==TurningLeft)&&!(done)))+((previous==TurningLeft)&&done))",0,0,0);
	trans[0][108]	= settr(0,0,0,0,0,"assert((guards==1))",0,0,0);
	T = trans[0][207] = settr(206,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,109,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,116,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,123,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,130,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,137,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,144,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,151,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,158,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,165,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,172,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,179,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,186,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(206,2,193,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(206,2,200,0,0,"IF", 1, 2, 0);
	trans[0][109]	= settr(108,2,115,47,0,"(((previous==Forward)&&!(front)))", 1, 2, 0);
	T = trans[ 0][115] = settr(114,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(114,0,110,0,0,"sub-sequence", 1, 2, 0);
	trans[0][110]	= settr(109,2,219,48,48,"transition = 1", 1, 2, 0); /* m: 111 -> 0,219 */
	reached0[111] = 1;
	trans[0][111]	= settr(0,0,0,0,0,"state = 14",0,0,0);
	trans[0][112]	= settr(0,0,0,0,0,"command = 9",0,0,0);
	trans[0][113]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][114]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][208]	= settr(207,2,209,1,0,".(goto)", 1, 2, 0); /* m: 209 -> 0,219 */
	reached0[209] = 1;
	trans[0][116]	= settr(115,2,122,49,0,"(((previous==Forward)&&front))", 1, 2, 0);
	T = trans[ 0][122] = settr(121,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(121,0,117,0,0,"sub-sequence", 1, 2, 0);
	trans[0][117]	= settr(116,2,219,50,50,"transition = 2", 1, 2, 0); /* m: 118 -> 0,219 */
	reached0[118] = 1;
	trans[0][118]	= settr(0,0,0,0,0,"state = 13",0,0,0);
	trans[0][119]	= settr(0,0,0,0,0,"command = 8",0,0,0);
	trans[0][120]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][121]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][123]	= settr(122,2,129,51,0,"(((previous==Stopping)&&!(done)))", 1, 2, 0);
	T = trans[ 0][129] = settr(128,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(128,0,124,0,0,"sub-sequence", 1, 2, 0);
	trans[0][124]	= settr(123,2,219,52,52,"transition = 3", 1, 2, 0); /* m: 125 -> 0,219 */
	reached0[125] = 1;
	trans[0][125]	= settr(0,0,0,0,0,"state = 13",0,0,0);
	trans[0][126]	= settr(0,0,0,0,0,"command = 8",0,0,0);
	trans[0][127]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][128]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][130]	= settr(129,2,136,53,0,"((((previous==Stopping)&&done)&&(side==RightOpen)))", 1, 2, 0);
	T = trans[ 0][136] = settr(135,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(135,0,131,0,0,"sub-sequence", 1, 2, 0);
	trans[0][131]	= settr(130,2,219,54,54,"transition = 4", 1, 2, 0); /* m: 132 -> 0,219 */
	reached0[132] = 1;
	trans[0][132]	= settr(0,0,0,0,0,"state = 11",0,0,0);
	trans[0][133]	= settr(0,0,0,0,0,"command = 6",0,0,0);
	trans[0][134]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][135]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][137]	= settr(136,2,143,55,0,"((((previous==Stopping)&&done)&&(side==LeftOpen)))", 1, 2, 0);
	T = trans[ 0][143] = settr(142,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(142,0,138,0,0,"sub-sequence", 1, 2, 0);
	trans[0][138]	= settr(137,2,219,56,56,"transition = 5", 1, 2, 0); /* m: 139 -> 0,219 */
	reached0[139] = 1;
	trans[0][139]	= settr(0,0,0,0,0,"state = 10",0,0,0);
	trans[0][140]	= settr(0,0,0,0,0,"command = 5",0,0,0);
	trans[0][141]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][142]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][144]	= settr(143,2,150,57,0,"((((previous==Stopping)&&done)&&(side==SidesBlocked)))", 1, 2, 0);
	T = trans[ 0][150] = settr(149,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(149,0,145,0,0,"sub-sequence", 1, 2, 0);
	trans[0][145]	= settr(144,2,219,58,58,"transition = 6", 1, 2, 0); /* m: 146 -> 0,219 */
	reached0[146] = 1;
	trans[0][146]	= settr(0,0,0,0,0,"state = 12",0,0,0);
	trans[0][147]	= settr(0,0,0,0,0,"command = 7",0,0,0);
	trans[0][148]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][149]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][151]	= settr(150,2,157,59,0,"(((previous==Backing)&&!(done)))", 1, 2, 0);
	T = trans[ 0][157] = settr(156,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(156,0,152,0,0,"sub-sequence", 1, 2, 0);
	trans[0][152]	= settr(151,2,219,60,60,"transition = 7", 1, 2, 0); /* m: 153 -> 0,219 */
	reached0[153] = 1;
	trans[0][153]	= settr(0,0,0,0,0,"state = 12",0,0,0);
	trans[0][154]	= settr(0,0,0,0,0,"command = 7",0,0,0);
	trans[0][155]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][156]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][158]	= settr(157,2,164,61,0,"((((previous==Backing)&&done)&&(side==SidesBlocked)))", 1, 2, 0);
	T = trans[ 0][164] = settr(163,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(163,0,159,0,0,"sub-sequence", 1, 2, 0);
	trans[0][159]	= settr(158,2,219,62,62,"transition = 8", 1, 2, 0); /* m: 160 -> 0,219 */
	reached0[160] = 1;
	trans[0][160]	= settr(0,0,0,0,0,"state = 12",0,0,0);
	trans[0][161]	= settr(0,0,0,0,0,"command = 7",0,0,0);
	trans[0][162]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][163]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][165]	= settr(164,2,171,63,0,"((((previous==Backing)&&done)&&(side==RightOpen)))", 1, 2, 0);
	T = trans[ 0][171] = settr(170,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(170,0,166,0,0,"sub-sequence", 1, 2, 0);
	trans[0][166]	= settr(165,2,219,64,64,"transition = 9", 1, 2, 0); /* m: 167 -> 0,219 */
	reached0[167] = 1;
	trans[0][167]	= settr(0,0,0,0,0,"state = 11",0,0,0);
	trans[0][168]	= settr(0,0,0,0,0,"command = 6",0,0,0);
	trans[0][169]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][170]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][172]	= settr(171,2,178,65,0,"((((previous==Backing)&&done)&&(side==LeftOpen)))", 1, 2, 0);
	T = trans[ 0][178] = settr(177,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(177,0,173,0,0,"sub-sequence", 1, 2, 0);
	trans[0][173]	= settr(172,2,219,66,66,"transition = 10", 1, 2, 0); /* m: 174 -> 0,219 */
	reached0[174] = 1;
	trans[0][174]	= settr(0,0,0,0,0,"state = 10",0,0,0);
	trans[0][175]	= settr(0,0,0,0,0,"command = 5",0,0,0);
	trans[0][176]	= settr(0,0,0,0,0,"start_timer = 1",0,0,0);
	trans[0][177]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][179]	= settr(178,2,185,67,0,"(((previous==TurningRight)&&!(done)))", 1, 2, 0);
	T = trans[ 0][185] = settr(184,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(184,0,180,0,0,"sub-sequence", 1, 2, 0);
	trans[0][180]	= settr(179,2,219,68,68,"transition = 11", 1, 2, 0); /* m: 181 -> 0,219 */
	reached0[181] = 1;
	trans[0][181]	= settr(0,0,0,0,0,"state = 11",0,0,0);
	trans[0][182]	= settr(0,0,0,0,0,"command = 6",0,0,0);
	trans[0][183]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][184]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][186]	= settr(185,2,192,69,0,"(((previous==TurningRight)&&done))", 1, 2, 0);
	T = trans[ 0][192] = settr(191,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(191,0,187,0,0,"sub-sequence", 1, 2, 0);
	trans[0][187]	= settr(186,2,219,70,70,"transition = 12", 1, 2, 0); /* m: 188 -> 0,219 */
	reached0[188] = 1;
	trans[0][188]	= settr(0,0,0,0,0,"state = 14",0,0,0);
	trans[0][189]	= settr(0,0,0,0,0,"command = 9",0,0,0);
	trans[0][190]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][191]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][193]	= settr(192,2,199,71,0,"(((previous==TurningLeft)&&!(done)))", 1, 2, 0);
	T = trans[ 0][199] = settr(198,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(198,0,194,0,0,"sub-sequence", 1, 2, 0);
	trans[0][194]	= settr(193,2,219,72,72,"transition = 13", 1, 2, 0); /* m: 195 -> 0,219 */
	reached0[195] = 1;
	trans[0][195]	= settr(0,0,0,0,0,"state = 10",0,0,0);
	trans[0][196]	= settr(0,0,0,0,0,"command = 5",0,0,0);
	trans[0][197]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][198]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][200]	= settr(199,2,206,73,0,"(((previous==TurningLeft)&&done))", 1, 2, 0);
	T = trans[ 0][206] = settr(205,0,0,0,0,"sub-sequence", 1, 2, 0);
	T->nxt	= settr(205,0,201,0,0,"sub-sequence", 1, 2, 0);
	trans[0][201]	= settr(200,2,219,74,74,"transition = 14", 1, 2, 0); /* m: 202 -> 0,219 */
	reached0[202] = 1;
	trans[0][202]	= settr(0,0,0,0,0,"state = 14",0,0,0);
	trans[0][203]	= settr(0,0,0,0,0,"command = 9",0,0,0);
	trans[0][204]	= settr(0,0,0,0,0,"start_timer = 0",0,0,0);
	trans[0][205]	= settr(0,0,0,0,0,"emitted = (emitted+1)",0,0,0);
	trans[0][209]	= settr(208,2,219,75,75,"assert((emitted==1))", 1, 2, 0);
	T = trans[0][219] = settr(218,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(218,2,210,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(218,2,212,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(218,2,214,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(218,2,217,0,0,"IF", 1, 2, 0);
	trans[0][210]	= settr(209,2,227,76,76,"((previous==Forward))", 1, 2, 0); /* m: 211 -> 227,0 */
	reached0[211] = 1;
	trans[0][211]	= settr(0,0,0,0,0,"assert((((front&&(state==Stopping))&&start_timer)||((!(front)&&(state==Forward))&&!(start_timer))))",0,0,0);
	trans[0][220]	= settr(219,2,227,1,0,".(goto)", 1, 2, 0);
	trans[0][212]	= settr(211,2,227,77,77,"(((previous!=Forward)&&!(done)))", 1, 2, 0); /* m: 213 -> 227,0 */
	reached0[213] = 1;
	trans[0][213]	= settr(0,0,0,0,0,"assert(((state==previous)&&!(start_timer)))",0,0,0);
	trans[0][214]	= settr(213,2,227,78,78,"((((previous==Stopping)||(previous==Backing))&&done))", 1, 2, 0); /* m: 215 -> 227,0 */
	reached0[215] = 1;
	trans[0][215]	= settr(0,0,0,0,0,"assert(start_timer)",0,0,0);
	trans[0][216]	= settr(0,0,0,0,0,"assert((((!(right)&&(state==TurningRight))||((right&&!(left))&&(state==TurningLeft)))||((right&&left)&&(state==Backing))))",0,0,0);
	trans[0][217]	= settr(216,2,227,79,79,"((((previous==TurningRight)||(previous==TurningLeft))&&done))", 1, 2, 0); /* m: 218 -> 227,0 */
	reached0[218] = 1;
	trans[0][218]	= settr(0,0,0,0,0,"assert(((state==Forward)&&!(start_timer)))",0,0,0);
	T = trans[0][227] = settr(226,2,0,0,0,"IF", 1, 2, 0);
	T = T->nxt	= settr(226,2,221,0,0,"IF", 1, 2, 0);
	    T->nxt	= settr(226,2,225,0,0,"IF", 1, 2, 0);
	trans[0][221]	= settr(220,0,239,80,80,"(start_timer)", 1, 2, 0); /* m: 222 -> 239,0 */
	reached0[222] = 1;
	trans[0][222]	= settr(0,0,0,0,0,"assert((remaining==0))",0,0,0);
	trans[0][223]	= settr(0,0,0,0,0,"elapsed = 0",0,0,0);
	trans[0][224]	= settr(0,0,0,0,0,"remaining = 5",0,0,0);
	trans[0][228]	= settr(227,2,229,1,0,".(goto)", 1, 2, 0); /* m: 229 -> 0,239 */
	reached0[229] = 1;
	trans[0][225]	= settr(224,2,226,2,0,"else", 1, 2, 0);
	trans[0][226]	= settr(225,0,239,81,81,"(1)", 1, 2, 0); /* m: 229 -> 239,0 */
	reached0[229] = 1;
	trans[0][229]	= settr(228,0,239,82,82,"direction = command", 1, 2, 0); /* m: 230 -> 0,239 */
	reached0[230] = 1;
	trans[0][230]	= settr(0,0,0,0,0,"avoiding = (command!=GoForward)",0,0,0);
	trans[0][231]	= settr(0,0,0,0,0,"assert(((((((state==Forward)&&(command==GoForward))||((state==Stopping)&&(command==Stop)))||((state==Backing)&&(command==GoBackward)))||((state==TurningRight)&&(command==TurnRight)))||((state==TurningLeft)&&(command==TurnLeft))))",0,0,0);
	trans[0][232]	= settr(0,0,0,0,0,"assert(((direction==command)&&(avoiding==(state!=Forward))))",0,0,0);
	trans[0][233]	= settr(0,0,0,0,0,"assert(((((state==Forward)&&(elapsed==6))&&(remaining==0))||(((state!=Forward)&&(elapsed<5))&&(remaining==(5-elapsed)))))",0,0,0);
	trans[0][234]	= settr(0,0,0,0,0,"printf('T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\\n',transition,previous,front,left,right,done,state,command,elapsed,remaining)",0,0,0);
	trans[0][235]	= settr(0,0,0,0,0,"stable = 1",0,0,0);
	trans[0][236]	= settr(0,0,0,0,0,"assert((transition!=255))",0,0,0);
	trans[0][237]	= settr(0,0,0,0,0,"assert((state!=0))",0,0,0);
	trans[0][241]	= settr(240,0,242,1,0,"break", 0, 2, 0);
	trans[0][242]	= settr(241,0,0,83,83,"-end-", 0, 3500, 0);
	/* np_ demon: */
	trans[_NP_] = (Trans **) emalloc(3*sizeof(Trans *));
	T = trans[_NP_][0] = settr(9997,0,1,_T5,0,"(np_)", 1,2,0);
	    T->nxt	  = settr(9998,0,0,_T2,0,"(1)",   0,2,0);
	T = trans[_NP_][1] = settr(9999,0,1,_T5,0,"(np_)", 1,2,0);
}

Trans *
settr(	int t_id, int a, int b, int c, int d,
	char *t, int g, int tpe0, int tpe1)
{	Trans *tmp = (Trans *) emalloc(sizeof(Trans));

	tmp->atom  = a&(6|32);	/* only (2|8|32) have meaning */
	if (!g) tmp->atom |= 8;	/* no global references */
	tmp->st    = b;
	tmp->tpe[0] = tpe0;
	tmp->tpe[1] = tpe1;
	tmp->tp    = t;
	tmp->t_id  = t_id;
	tmp->forw  = c;
	tmp->back  = d;
	return tmp;
}

Trans *
cpytr(Trans *a)
{	Trans *tmp = (Trans *) emalloc(sizeof(Trans));

	int i;
	tmp->atom  = a->atom;
	tmp->st    = a->st;
#ifdef HAS_UNLESS
	tmp->e_trans = a->e_trans;
	for (i = 0; i < HAS_UNLESS; i++)
		tmp->escp[i] = a->escp[i];
#endif
	tmp->tpe[0] = a->tpe[0];
	tmp->tpe[1] = a->tpe[1];
	for (i = 0; i < 6; i++)
	{	tmp->qu[i] = a->qu[i];
		tmp->ty[i] = a->ty[i];
	}
	tmp->tp    = (char *) emalloc(strlen(a->tp)+1);
	strcpy(tmp->tp, a->tp);
	tmp->t_id  = a->t_id;
	tmp->forw  = a->forw;
	tmp->back  = a->back;
	return tmp;
}

#ifndef NOREDUCE
int
srinc_set(int n)
{	if (n <= 2) return LOCAL;
	if (n <= 2+  DELTA) return Q_FULL_F; /* 's' or nfull  */
	if (n <= 2+2*DELTA) return Q_EMPT_F; /* 'r' or nempty */
	if (n <= 2+3*DELTA) return Q_EMPT_T; /* empty */
	if (n <= 2+4*DELTA) return Q_FULL_T; /* full  */
	if (n ==   5*DELTA) return GLOBAL;
	if (n ==   6*DELTA) return TIMEOUT_F;
	if (n ==   7*DELTA) return ALPHA_F;
	Uerror("cannot happen srinc_class");
	return BAD;
}
int
srunc(int n, int m)
{	switch(m) {
	case Q_FULL_F: return n-2;
	case Q_EMPT_F: return n-2-DELTA;
	case Q_EMPT_T: return n-2-2*DELTA;
	case Q_FULL_T: return n-2-3*DELTA;
	case ALPHA_F:
	case TIMEOUT_F: return 257; /* non-zero, and > MAXQ */
	}
	Uerror("cannot happen srunc");
	return 0;
}
#endif
int cnt;
#ifdef HAS_UNLESS
int
isthere(Trans *a, int b)
{	Trans *t;
	for (t = a; t; t = t->nxt)
		if (t->t_id == b)
			return 1;
	return 0;
}
#endif
#ifndef NOREDUCE
int
mark_safety(Trans *t) /* for conditional safety */
{	int g = 0, i, j, k;

	if (!t) return 0;
	if (t->qu[0])
		return (t->qu[1])?2:1;	/* marked */

	for (i = 0; i < 2; i++)
	{	j = srinc_set(t->tpe[i]);
		if (j >= GLOBAL && j != ALPHA_F)
			return -1;
		if (j != LOCAL)
		{	k = srunc(t->tpe[i], j);
			if (g == 0
			||  t->qu[0] != k
			||  t->ty[0] != j)
			{	t->qu[g] = k;
				t->ty[g] = j;
				g++;
	}	}	}
	return g;
}
#endif
void
retrans(int n, int m, int is, short srcln[], uchar reach[], uchar lpstate[])
	/* process n, with m states, is=initial state */
{	Trans *T0, *T1, *T2, *T3;
	Trans *T4, *T5; /* t_reverse or has_unless */
	int i;
#if defined(HAS_UNLESS) || !defined(NOREDUCE)
	int k;
#endif
#ifndef NOREDUCE
	int g, h, j, aa;
#endif
#ifdef HAS_UNLESS
	int p;
#endif
	if (state_tables >= 4)
	{	printf("STEP 1 %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
		return;
	}
	do {
		for (i = 1, cnt = 0; i < m; i++)
		{	T2 = trans[n][i];
			T1 = T2?T2->nxt:(Trans *)0;
/* prescan: */		for (T0 = T1; T0; T0 = T0->nxt)
/* choice in choice */	{	if (T0->st && trans[n][T0->st]
				&&  trans[n][T0->st]->nxt)
					break;
			}
#if 0
		if (T0)
		printf("\tstate %d / %d: choice in choice\n",
		i, T0->st);
#endif
			if (T0)
			for (T0 = T1; T0; T0 = T0->nxt)
			{	T3 = trans[n][T0->st];
				if (!T3->nxt)
				{	T2->nxt = cpytr(T0);
					T2 = T2->nxt;
					imed(T2, T0->st, n, i);
					continue;
				}
				do {	T3 = T3->nxt;
					T2->nxt = cpytr(T3);
					T2 = T2->nxt;
					imed(T2, T0->st, n, i);
				} while (T3->nxt);
				cnt++;
			}
		}
	} while (cnt);
	if (state_tables >= 3)
	{	printf("STEP 2 %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
		return;
	}
	for (i = 1; i < m; i++)
	{	if (trans[n][i] && trans[n][i]->nxt) /* optimize */
		{	T1 = trans[n][i]->nxt;
#if 0
			printf("\t\tpull %d (%d) to %d\n",
			T1->st, T1->forw, i);
#endif
			srcln[i] = srcln[T1->st];	/* Oyvind Teig, 5.2.0 */

			if (!trans[n][T1->st]) continue;
			T0 = cpytr(trans[n][T1->st]);
			trans[n][i] = T0;
			reach[T1->st] = 1;
			imed(T0, T1->st, n, i);
			for (T1 = T1->nxt; T1; T1 = T1->nxt)
			{
#if 0
			printf("\t\tpull %d (%d) to %d\n",
				T1->st, T1->forw, i);
#endif
		/*		srcln[i] = srcln[T1->st];  gh: not useful */
				if (!trans[n][T1->st]) continue;
				T0->nxt = cpytr(trans[n][T1->st]);
				T0 = T0->nxt;
				reach[T1->st] = 1;
				imed(T0, T1->st, n, i);
	}	}	}
	if (state_tables >= 2)
	{	printf("STEP 3 %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
		return;
	}
#ifdef HAS_UNLESS
	for (i = 1; i < m; i++)
	{	if (!trans[n][i]) continue;
		/* check for each state i if an
		 * escape to some state p is defined
		 * if so, copy and mark p's transitions
		 * and prepend them to the transition-
		 * list of state i
		 */
	 if (!like_java) /* the default */
	 {	for (T0 = trans[n][i]; T0; T0 = T0->nxt)
		for (k = HAS_UNLESS-1; k >= 0; k--)
		{	if (p = T0->escp[k])
			for (T1 = trans[n][p]; T1; T1 = T1->nxt)
			{	if (isthere(trans[n][i], T1->t_id))
					continue;
				T2 = cpytr(T1);
				T2->e_trans = p;
				T2->nxt = trans[n][i];
				trans[n][i] = T2;
		}	}
	 } else /* outermost unless checked first */
	 {	T4 = T3 = (Trans *) 0;
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
		for (k = HAS_UNLESS-1; k >= 0; k--)
		{	if (p = T0->escp[k])
			for (T1 = trans[n][p]; T1; T1 = T1->nxt)
			{	if (isthere(trans[n][i], T1->t_id))
					continue;
				T2 = cpytr(T1);
				T2->nxt = (Trans *) 0;
				T2->e_trans = p;
				if (T3)	T3->nxt = T2;
				else	T4 = T2;
				T3 = T2;
		}	}
		if (T4)
		{	T3->nxt = trans[n][i];
			trans[n][i] = T4;
		}
	 }
	}
#endif
#ifndef NOREDUCE
	for (i = 1; i < m; i++)
	{	if (a_cycles)
		{ /* moves through these states are visible */
	#if PROG_LAB>0 && defined(HAS_NP)
			if (progstate[n][i])
				goto degrade;
			for (T1 = trans[n][i]; T1; T1 = T1->nxt)
				if (progstate[n][T1->st])
					goto degrade;
	#endif
			if (accpstate[n][i] || visstate[n][i])
				goto degrade;
			for (T1 = trans[n][i]; T1; T1 = T1->nxt)
				if (accpstate[n][T1->st])
					goto degrade;
		}
		T1 = trans[n][i];
		if (!T1) continue;
		g = mark_safety(T1);	/* V3.3.1 */
		if (g < 0) goto degrade; /* global */
		/* check if mixing of guards preserves reduction */
		if (T1->nxt)
		{	k = 0;
			for (T0 = T1; T0; T0 = T0->nxt)
			{	if (!(T0->atom&8))
					goto degrade;
				for (aa = 0; aa < 2; aa++)
				{	j = srinc_set(T0->tpe[aa]);
					if (j >= GLOBAL && j != ALPHA_F)
						goto degrade;
					if (T0->tpe[aa]
					&&  T0->tpe[aa]
					!=  T1->tpe[0])
						k = 1;
			}	}
			/* g = 0;	V3.3.1 */
			if (k)	/* non-uniform selection */
			for (T0 = T1; T0; T0 = T0->nxt)
			for (aa = 0; aa < 2; aa++)
			{	j = srinc_set(T0->tpe[aa]);
				if (j != LOCAL)
				{	k = srunc(T0->tpe[aa], j);
					for (h = 0; h < 6; h++)
						if (T1->qu[h] == k
						&&  T1->ty[h] == j)
							break;
					if (h >= 6)
					{	T1->qu[g%6] = k;
						T1->ty[g%6] = j;
						g++;
			}	}	}
			if (g > 6)
			{	T1->qu[0] = 0;	/* turn it off */
				printf("pan: warning, line %d, ",
					srcln[i]);
			 	printf("too many stmnt types (%d)",
					g);
			  	printf(" in selection\n");
			  goto degrade;
			}
		}
		/* mark all options global if >=1 is global */
		for (T1 = trans[n][i]; T1; T1 = T1->nxt)
			if (!(T1->atom&8)) break;
		if (T1)
degrade:	for (T1 = trans[n][i]; T1; T1 = T1->nxt)
			T1->atom &= ~8;	/* mark as unsafe */
		/* can only mix 'r's or 's's if on same chan */
		/* and not mixed with other local operations */
		T1 = trans[n][i];
		if (!T1 || T1->qu[0]) continue;
		j = T1->tpe[0];
		if (T1->nxt && T1->atom&8)
		{ if (j == 5*DELTA)
		  {	printf("warning: line %d ", srcln[i]);
			printf("mixed condition ");
			printf("(defeats reduction)\n");
			goto degrade;
		  }
		  for (T0 = T1; T0; T0 = T0->nxt)
		  for (aa = 0; aa < 2; aa++)
		  if  (T0->tpe[aa] && T0->tpe[aa] != j)
		  {	printf("warning: line %d ", srcln[i]);
			printf("[%d-%d] mixed %stion ",
				T0->tpe[aa], j, 
				(j==5*DELTA)?"condi":"selec");
			printf("(defeats reduction)\n");
			printf("	'%s' <-> '%s'\n",
				T1->tp, T0->tp);
			goto degrade;
		} }
	}
#endif
	for (i = 1; i < m; i++)
	{	T2 = trans[n][i];
		if (!T2
		||  T2->nxt
		||  strncmp(T2->tp, ".(goto)", 7)
		||  !stopstate[n][i])
			continue;
		stopstate[n][T2->st] = 1;
	}
	if (state_tables && !verbose)
	{	if (dodot)
		{	char buf[256], *q = buf, *p = procname[n];
			while (*p != '\0')
			{	if (*p != ':')
				{	*q++ = *p;
				}
				p++;
			}
			*q = '\0';
			printf("digraph ");
			switch (Btypes[n]) {
			case I_PROC:  printf("init {\n"); break;
			case N_CLAIM: printf("claim_%s {\n", buf); break;
			case E_TRACE: printf("notrace {\n"); break;
			case N_TRACE: printf("trace {\n"); break;
			default:      printf("p_%s {\n", buf); break;
			}
			printf("size=\"8,10\";\n");
			printf("  GT [shape=box,style=dotted,label=\"%s\"];\n", buf);
			printf("  GT -> S%d;\n", is);
		} else
		{	switch (Btypes[n]) {
			case I_PROC:  printf("init\n"); break;
			case N_CLAIM: printf("claim %s\n", procname[n]); break;
			case E_TRACE: printf("notrace assertion\n"); break;
			case N_TRACE: printf("trace assertion\n"); break;
			default:      printf("proctype %s\n", procname[n]); break;
		}	}
		for (i = 1; i < m; i++)
		{	reach[i] = 1;
		}
		tagtable(n, m, is, srcln, reach);
		if (dodot) printf("}\n");
	} else
	for (i = 1; i < m; i++)
	{	int nrelse;
		if (Btypes[n] != N_CLAIM)
		{	for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			{	if (T0->st == i
				&& strcmp(T0->tp, "(1)") == 0)
				{	printf("error: proctype '%s' ",
						procname[n]);
		  			printf("line %d, state %d: has un",
						srcln[i], i);
					printf("conditional self-loop\n");
					pan_exit(1);
		}	}	}
		nrelse = 0;
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
		{	if (strcmp(T0->tp, "else") == 0)
				nrelse++;
		}
		if (nrelse > 1)
		{	printf("error: proctype '%s' state",
				procname[n]);
		  	printf(" %d, inherits %d", i, nrelse);
		  	printf(" 'else' stmnts\n");
			pan_exit(1);
	}	}
#if !defined(LOOPSTATE) && !defined(BFS_PAR)
	if (state_tables)
#endif
	do_dfs(n, m, is, srcln, reach, lpstate);

	if (!t_reverse)
	{	return;
	}
	/* process n, with m states, is=initial state -- reverse list */
	if (!state_tables && Btypes[n] != N_CLAIM)
	{	for (i = 1; i < m; i++)
		{	Trans *Tx = (Trans *) 0; /* list of escapes */
			Trans *Ty = (Trans *) 0; /* its tail element */
			T1 = (Trans *) 0; /* reversed list */
			T2 = (Trans *) 0; /* its tail */
			T3 = (Trans *) 0; /* remembers possible 'else' */

			/* find unless-escapes, they should go first */
			T4 = T5 = T0 = trans[n][i];
	#ifdef HAS_UNLESS
			while (T4 && T4->e_trans) /* escapes are first in orig list */
			{	T5 = T4;	  /* remember predecessor */
				T4 = T4->nxt;
			}
	#endif
			/* T4 points to first non-escape, T5 to its parent, T0 to original list */
			if (T4 != T0)		 /* there was at least one escape */
			{	T3 = T5->nxt;		 /* start of non-escapes */
				T5->nxt = (Trans *) 0;	 /* separate */
				Tx = T0;		 /* start of the escapes */
				Ty = T5;		 /* its tail */
				T0 = T3;		 /* the rest, to be reversed */
			}
			/* T0 points to first non-escape, Tx to the list of escapes, Ty to its tail */

			/* first tail-add non-escape transitions, reversed */
			T3 = (Trans *) 0;
			for (T5 = T0; T5; T5 = T4)
			{	T4 = T5->nxt;
	#ifdef HAS_UNLESS
				if (T5->e_trans)
				{	printf("error: cannot happen!\n");
					continue;
				}
	#endif
				if (strcmp(T5->tp, "else") == 0)
				{	T3 = T5;
					T5->nxt = (Trans *) 0;
				} else
				{	T5->nxt = T1;
					if (!T1) { T2 = T5; }
					T1 = T5;
			}	}
			/* T3 points to a possible else, which is removed from the list */
			/* T1 points to the reversed list so far (without escapes) */
			/* T2 points to the tail element -- where the else should go */
			if (T2 && T3)
			{	T2->nxt = T3;	/* add else */
			} else
			{	if (T3) /* there was an else, but there's no tail */
				{	if (!T1)	/* and no reversed list */
					{	T1 = T3; /* odd, but possible */
					} else		/* even stranger */
					{	T1->nxt = T3;
			}	}	}

			/* add in the escapes, to that they appear at the front */
			if (Tx && Ty) { Ty->nxt = T1; T1 = Tx; }

			trans[n][i] = T1;
			/* reversed, with escapes first and else last */
	}	}
	if (state_tables && verbose)
	{	printf("FINAL proctype %s\n", 
			procname[n]);
		for (i = 1; i < m; i++)
		for (T0 = trans[n][i]; T0; T0 = T0->nxt)
			crack(n, i, T0, srcln);
	}
}
void
imed(Trans *T, int v, int n, int j)	/* set intermediate state */
{	progstate[n][T->st] |= progstate[n][v];
	accpstate[n][T->st] |= accpstate[n][v];
	stopstate[n][T->st] |= stopstate[n][v];
	mapstate[n][j] = T->st;
}
void
tagtable(int n, int m, int is, short srcln[], uchar reach[])
{	Trans *z;

	if (is >= m || !trans[n][is]
	||  is <= 0 || reach[is] == 0)
		return;
	reach[is] = 0;
	if (state_tables)
	for (z = trans[n][is]; z; z = z->nxt)
	{	if (dodot)
			dot_crack(n, is, z);
		else
			crack(n, is, z, srcln);
	}

	for (z = trans[n][is]; z; z = z->nxt)
	{
#ifdef HAS_UNLESS
		int i, j;
#endif
		tagtable(n, m, z->st, srcln, reach);
#ifdef HAS_UNLESS
		for (i = 0; i < HAS_UNLESS; i++)
		{	j = trans[n][is]->escp[i];
			if (!j) break;
			tagtable(n, m, j, srcln, reach);
		}
#endif
	}
}

extern Trans *t_id_lkup[];

void
dfs_table(int n, int m, int is, short srcln[], uchar reach[], uchar lpstate[])
{	Trans *z;

	if (is >= m || is <= 0 || !trans[n][is])
		return;
	if ((reach[is] & (4|8|16)) != 0)
	{	if ((reach[is] & (8|16)) == 16)	/* on stack, not yet recorded */
		{	lpstate[is] = 1;
			reach[is] |= 8; /* recorded */
			if (state_tables && verbose)
			{	printf("state %d line %d is a loopstate\n", is, srcln[is]);
		}	}
		return;
	}
	reach[is] |= (4|16);	/* visited | onstack */
	for (z = trans[n][is]; z; z = z->nxt)
	{	t_id_lkup[z->t_id] = z;
#ifdef HAS_UNLESS
		int i, j;
#endif
		dfs_table(n, m, z->st, srcln, reach, lpstate);
#ifdef HAS_UNLESS
		for (i = 0; i < HAS_UNLESS; i++)
		{	j = trans[n][is]->escp[i];
			if (!j) break;
			dfs_table(n, m, j, srcln, reach, lpstate);
		}
#endif
	}
	reach[is] &= ~16; /* no longer on stack */
}
void
do_dfs(int n, int m, int is, short srcln[], uchar reach[], uchar lpstate[])
{	int i;
	dfs_table(n, m, is, srcln, reach, lpstate);
	for (i = 0; i < m; i++)
		reach[i] &= ~(4|8|16);
}
void
crack(int n, int j, Trans *z, short srcln[])
{	int i;

	if (!z) return;
	printf("	state %3d -(tr %3d)-> state %3d  ",
		j, z->forw, z->st);
	printf("[id %3d tp %3d", z->t_id, z->tpe[0]);
	if (z->tpe[1]) printf(",%d", z->tpe[1]);
#ifdef HAS_UNLESS
	if (z->e_trans)
		printf(" org %3d", z->e_trans);
	else if (state_tables >= 2)
	for (i = 0; i < HAS_UNLESS; i++)
	{	if (!z->escp[i]) break;
		printf(" esc %d", z->escp[i]);
	}
#endif
	printf("]");
	printf(" [%s%s%s%s%s] %s:%d => ",
		z->atom&6?"A":z->atom&32?"D":"-",
		accpstate[n][j]?"a" :"-",
		stopstate[n][j]?"e" : "-",
		progstate[n][j]?"p" : "-",
		z->atom & 8 ?"L":"G",
		PanSource, srcln[j]);
	for (i = 0; z->tp[i]; i++)
		if (z->tp[i] == '\n')
			printf("\\n");
		else
			putchar(z->tp[i]);
	if (verbose && z->qu[0])
	{	printf("\t[");
		for (i = 0; i < 6; i++)
			if (z->qu[i])
				printf("(%d,%d)",
				z->qu[i], z->ty[i]);
		printf("]");
	}
	printf("\n");
	fflush(stdout);
}
/* spin -a m.pml; cc -o pan pan.c; ./pan -D | dot -Tps > foo.ps; ps2pdf foo.ps */
void
dot_crack(int n, int j, Trans *z)
{	int i;

	if (!z) return;
	printf("	S%d -> S%d  [color=black", j, z->st);

	if (z->atom&6) printf(",style=dashed");
	else if (z->atom&32) printf(",style=dotted");
	else if (z->atom&8) printf(",style=solid");
	else printf(",style=bold");

	printf(",label=\"");
	for (i = 0; z->tp[i]; i++)
	{	if (z->tp[i] == '\\'
		&&  z->tp[i+1] == 'n')
		{	i++; printf(" ");
		} else
		{	putchar(z->tp[i]);
	}	}
	printf("\"];\n");
	if (accpstate[n][j]) printf("  S%d [color=red,style=bold];\n", j);
	else if (progstate[n][j]) printf("  S%d [color=green,style=bold];\n", j);
	if (stopstate[n][j]) printf("  S%d [color=blue,style=bold,shape=box];\n", j);
}

#ifdef VAR_RANGES
#define BYTESIZE	32	/* 2^8 : 2^3 = 256:8 = 32 */

typedef struct Vr_Ptr {
	char	*nm;
	uchar	vals[BYTESIZE];
	struct Vr_Ptr *nxt;
} Vr_Ptr;
Vr_Ptr *ranges = (Vr_Ptr *) 0;

void
logval(char *s, int v)
{	Vr_Ptr *tmp;

	if (v<0 || v > 255) return;
	for (tmp = ranges; tmp; tmp = tmp->nxt)
		if (!strcmp(tmp->nm, s))
			goto found;
	tmp = (Vr_Ptr *) emalloc(sizeof(Vr_Ptr));
	tmp->nxt = ranges;
	ranges = tmp;
	tmp->nm = s;
found:
	tmp->vals[(v)/8] |= 1<<((v)%8);
}

void
dumpval(uchar X[], int range)
{	int w, x, i, j = -1;

	for (w = i = 0; w < range; w++)
	for (x = 0; x < 8; x++, i++)
	{
from:		if ((X[w] & (1<<x)))
		{	printf("%d", i);
			j = i;
			goto upto;
	}	}
	return;
	for (w = 0; w < range; w++)
	for (x = 0; x < 8; x++, i++)
	{
upto:		if (!(X[w] & (1<<x)))
		{	if (i-1 == j)
				printf(", ");
			else
				printf("-%d, ", i-1);
			goto from;
	}	}
	if (j >= 0 && j != 255)
		printf("-255");
}

void
dumpranges(void)
{	Vr_Ptr *tmp;
	printf("\nValues assigned within ");
	printf("interval [0..255]:\n");
	for (tmp = ranges; tmp; tmp = tmp->nxt)
	{	printf("\t%s\t: ", tmp->nm);
		dumpval(tmp->vals, BYTESIZE);
		printf("\n");
	}
}
#endif
