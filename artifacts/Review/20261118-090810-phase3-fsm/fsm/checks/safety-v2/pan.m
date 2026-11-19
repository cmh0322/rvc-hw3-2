#define rand	pan_rand
#define pthread_equal(a,b)	((a)==(b))
#if defined(HAS_CODE) && defined(VERBOSE)
	#ifdef BFS_PAR
		bfs_printf("Pr: %d Tr: %d\n", II, t->forw);
	#else
		cpu_printf("Pr: %d Tr: %d\n", II, t->forw);
	#endif
#endif
	switch (t->forw) {
	default: Uerror("bad forward move");
	case 0:	/* if without executable clauses */
		continue;
	case 1: /* generic 'goto' or 'skip' */
		IfNotBlocked
		_m = 3; goto P999;
	case 2: /* generic 'else' */
		IfNotBlocked
		if (trpt->o_pm&1) continue;
		_m = 3; goto P999;

		 /* PROC Controller */
	case 3: // STATE 1 - model.pml:51 - [state = Forward] (0:35:2 - 1)
		IfNotBlocked
		reached[0][1] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = now.state;
		now.state = 14;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: previous = Forward(35, 2, 35) */
		reached[0][2] = 1;
		(trpt+1)->bup.ovals[1] = now.previous;
		now.previous = 14;
#ifdef VAR_RANGES
		logval("previous", now.previous);
#endif
		;
		/* merge: assert(((state==Forward)&&(elapsed==6)))(35, 3, 35) */
		reached[0][3] = 1;
		spin_assert(((now.state==14)&&(((int)now.elapsed)==6)), "((state==14)&&(elapsed==6))", II, tt, t);
		/* merge: assert(((command==NoCommand)&&(direction==NoCommand)))(35, 4, 35) */
		reached[0][4] = 1;
		spin_assert(((now.command==4)&&(now.direction==4)), "((command==4)&&(direction==4))", II, tt, t);
		/* merge: assert(((!(clean_emitted)&&!(start_timer))&&(emitted==0)))(35, 5, 35) */
		reached[0][5] = 1;
		spin_assert((( !(((int)now.clean_emitted))&& !(((int)now.start_timer)))&&(((int)now.emitted)==0)), "(( !(clean_emitted)&& !(start_timer))&&(emitted==0))", II, tt, t);
		/* merge: printf('INIT T0 state=%e command=%e elapsed=%d\\n',state,command,elapsed)(35, 6, 35) */
		reached[0][6] = 1;
		Printf("INIT T0 state=%e command=%e elapsed=%d\n", now.state, now.command, ((int)now.elapsed));
		/* merge: assert((transition!=255))(35, 7, 35) */
		reached[0][7] = 1;
		spin_assert((((int)now.transition)!=255), "(transition!=255)", II, tt, t);
		/* merge: assert((state!=0))(35, 8, 35) */
		reached[0][8] = 1;
		spin_assert((now.state!=0), "(state!=0)", II, tt, t);
		_m = 3; goto P999; /* 7 */
	case 4: // STATE 9 - model.pml:25 - [sampled = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][9] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = 0;
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 5: // STATE 10 - model.pml:27 - [((1&&(state==Stopping)))] (22:0:2 - 1)
		IfNotBlocked
		reached[0][10] = 1;
		if (!((1&&(now.state==13))))
			continue;
		/* merge: front = 1(22, 11, 22) */
		reached[0][11] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.front);
		now.front = 1;
#ifdef VAR_RANGES
		logval("front", ((int)now.front));
#endif
		;
		/* merge: .(goto)(22, 18, 22) */
		reached[0][18] = 1;
		;
		/* merge: sampled = (sampled|1)(22, 19, 22) */
		reached[0][19] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 6: // STATE 12 - model.pml:28 - [(!((1&&(state==Stopping))))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][12] = 1;
		if (!( !((1&&(now.state==13)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 7: // STATE 13 - model.pml:29 - [front = 0] (0:22:2 - 1)
		IfNotBlocked
		reached[0][13] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.front);
		now.front = 0;
#ifdef VAR_RANGES
		logval("front", ((int)now.front));
#endif
		;
		/* merge: .(goto)(22, 16, 22) */
		reached[0][16] = 1;
		;
		/* merge: .(goto)(22, 18, 22) */
		reached[0][18] = 1;
		;
		/* merge: sampled = (sampled|1)(22, 19, 22) */
		reached[0][19] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 8: // STATE 14 - model.pml:29 - [front = 1] (0:22:2 - 1)
		IfNotBlocked
		reached[0][14] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.front);
		now.front = 1;
#ifdef VAR_RANGES
		logval("front", ((int)now.front));
#endif
		;
		/* merge: .(goto)(22, 16, 22) */
		reached[0][16] = 1;
		;
		/* merge: .(goto)(22, 18, 22) */
		reached[0][18] = 1;
		;
		/* merge: sampled = (sampled|1)(22, 19, 22) */
		reached[0][19] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 9: // STATE 19 - model.pml:31 - [sampled = (sampled|1)] (0:22:1 - 5)
		IfNotBlocked
		reached[0][19] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 10: // STATE 20 - model.pml:32 - [left = 0] (0:27:2 - 1)
		IfNotBlocked
		reached[0][20] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.left);
		now.left = 0;
#ifdef VAR_RANGES
		logval("left", ((int)now.left));
#endif
		;
		/* merge: .(goto)(27, 23, 27) */
		reached[0][23] = 1;
		;
		/* merge: sampled = (sampled|2)(27, 24, 27) */
		reached[0][24] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|2);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 11: // STATE 21 - model.pml:32 - [left = 1] (0:27:2 - 1)
		IfNotBlocked
		reached[0][21] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.left);
		now.left = 1;
#ifdef VAR_RANGES
		logval("left", ((int)now.left));
#endif
		;
		/* merge: .(goto)(27, 23, 27) */
		reached[0][23] = 1;
		;
		/* merge: sampled = (sampled|2)(27, 24, 27) */
		reached[0][24] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|2);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 12: // STATE 24 - model.pml:33 - [sampled = (sampled|2)] (0:27:1 - 3)
		IfNotBlocked
		reached[0][24] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|2);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 13: // STATE 25 - model.pml:34 - [right = 0] (0:32:2 - 1)
		IfNotBlocked
		reached[0][25] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.right);
		now.right = 0;
#ifdef VAR_RANGES
		logval("right", ((int)now.right));
#endif
		;
		/* merge: .(goto)(32, 28, 32) */
		reached[0][28] = 1;
		;
		/* merge: sampled = (sampled|4)(32, 29, 32) */
		reached[0][29] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|4);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 14: // STATE 26 - model.pml:34 - [right = 1] (0:32:2 - 1)
		IfNotBlocked
		reached[0][26] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.right);
		now.right = 1;
#ifdef VAR_RANGES
		logval("right", ((int)now.right));
#endif
		;
		/* merge: .(goto)(32, 28, 32) */
		reached[0][28] = 1;
		;
		/* merge: sampled = (sampled|4)(32, 29, 32) */
		reached[0][29] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|4);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 15: // STATE 29 - model.pml:35 - [sampled = (sampled|4)] (0:32:1 - 3)
		IfNotBlocked
		reached[0][29] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|4);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 16: // STATE 30 - model.pml:36 - [dust = 0] (0:239:2 - 1)
		IfNotBlocked
		reached[0][30] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)dust);
		dust = 0;
#ifdef VAR_RANGES
		logval("dust", ((int)dust));
#endif
		;
		/* merge: .(goto)(239, 33, 239) */
		reached[0][33] = 1;
		;
		/* merge: sampled = (sampled|8)(239, 34, 239) */
		reached[0][34] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|8);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		/* merge: assert((sampled==15))(239, 36, 239) */
		reached[0][36] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: .(goto)(0, 240, 239) */
		reached[0][240] = 1;
		;
		_m = 3; goto P999; /* 4 */
	case 17: // STATE 31 - model.pml:36 - [dust = 1] (0:239:2 - 1)
		IfNotBlocked
		reached[0][31] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)dust);
		dust = 1;
#ifdef VAR_RANGES
		logval("dust", ((int)dust));
#endif
		;
		/* merge: .(goto)(239, 33, 239) */
		reached[0][33] = 1;
		;
		/* merge: sampled = (sampled|8)(239, 34, 239) */
		reached[0][34] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|8);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		/* merge: assert((sampled==15))(239, 36, 239) */
		reached[0][36] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: .(goto)(0, 240, 239) */
		reached[0][240] = 1;
		;
		_m = 3; goto P999; /* 4 */
	case 18: // STATE 34 - model.pml:37 - [sampled = (sampled|8)] (0:239:1 - 3)
		IfNotBlocked
		reached[0][34] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|8);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		/* merge: assert((sampled==15))(239, 36, 239) */
		reached[0][36] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: .(goto)(0, 240, 239) */
		reached[0][240] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 19: // STATE 38 - model.pml:64 - [stable = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][38] = 1;
		(trpt+1)->bup.oval = ((int)stable);
		stable = 0;
#ifdef VAR_RANGES
		logval("stable", ((int)stable));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 20: // STATE 39 - model.pml:65 - [(first_tick)] (82:0:5 - 1)
		IfNotBlocked
		reached[0][39] = 1;
		if (!(((int)now.first_tick)))
			continue;
		/* merge: first_tick = 0(82, 40, 82) */
		reached[0][40] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.first_tick);
		now.first_tick = 0;
#ifdef VAR_RANGES
		logval("first_tick", ((int)now.first_tick));
#endif
		;
		/* merge: .(goto)(82, 70, 82) */
		reached[0][70] = 1;
		;
		/* merge: assert((sampled==15))(82, 71, 82) */
		reached[0][71] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: previous = state(82, 72, 82) */
		reached[0][72] = 1;
		(trpt+1)->bup.ovals[1] = now.previous;
		now.previous = now.state;
#ifdef VAR_RANGES
		logval("previous", now.previous);
#endif
		;
		/* merge: emitted = 0(82, 73, 82) */
		reached[0][73] = 1;
		(trpt+1)->bup.ovals[2] = ((int)now.emitted);
		now.emitted = 0;
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: start_timer = 0(82, 74, 82) */
		reached[0][74] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: done = 0(82, 75, 82) */
		reached[0][75] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.done);
		now.done = 0;
#ifdef VAR_RANGES
		logval("done", ((int)now.done));
#endif
		;
		_m = 3; goto P999; /* 7 */
	case 21: // STATE 42 - model.pml:25 - [sampled = 0] (0:0:1 - 1)
		IfNotBlocked
		reached[0][42] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = 0;
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 22: // STATE 43 - model.pml:27 - [((1&&(state==Stopping)))] (55:0:2 - 1)
		IfNotBlocked
		reached[0][43] = 1;
		if (!((1&&(now.state==13))))
			continue;
		/* merge: front = 1(55, 44, 55) */
		reached[0][44] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.front);
		now.front = 1;
#ifdef VAR_RANGES
		logval("front", ((int)now.front));
#endif
		;
		/* merge: .(goto)(55, 51, 55) */
		reached[0][51] = 1;
		;
		/* merge: sampled = (sampled|1)(55, 52, 55) */
		reached[0][52] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 23: // STATE 45 - model.pml:28 - [(!((1&&(state==Stopping))))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][45] = 1;
		if (!( !((1&&(now.state==13)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 24: // STATE 46 - model.pml:29 - [front = 0] (0:55:2 - 1)
		IfNotBlocked
		reached[0][46] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.front);
		now.front = 0;
#ifdef VAR_RANGES
		logval("front", ((int)now.front));
#endif
		;
		/* merge: .(goto)(55, 49, 55) */
		reached[0][49] = 1;
		;
		/* merge: .(goto)(55, 51, 55) */
		reached[0][51] = 1;
		;
		/* merge: sampled = (sampled|1)(55, 52, 55) */
		reached[0][52] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 25: // STATE 47 - model.pml:29 - [front = 1] (0:55:2 - 1)
		IfNotBlocked
		reached[0][47] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.front);
		now.front = 1;
#ifdef VAR_RANGES
		logval("front", ((int)now.front));
#endif
		;
		/* merge: .(goto)(55, 49, 55) */
		reached[0][49] = 1;
		;
		/* merge: .(goto)(55, 51, 55) */
		reached[0][51] = 1;
		;
		/* merge: sampled = (sampled|1)(55, 52, 55) */
		reached[0][52] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 3 */
	case 26: // STATE 52 - model.pml:31 - [sampled = (sampled|1)] (0:55:1 - 5)
		IfNotBlocked
		reached[0][52] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|1);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 27: // STATE 53 - model.pml:32 - [left = 0] (0:60:2 - 1)
		IfNotBlocked
		reached[0][53] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.left);
		now.left = 0;
#ifdef VAR_RANGES
		logval("left", ((int)now.left));
#endif
		;
		/* merge: .(goto)(60, 56, 60) */
		reached[0][56] = 1;
		;
		/* merge: sampled = (sampled|2)(60, 57, 60) */
		reached[0][57] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|2);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 28: // STATE 54 - model.pml:32 - [left = 1] (0:60:2 - 1)
		IfNotBlocked
		reached[0][54] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.left);
		now.left = 1;
#ifdef VAR_RANGES
		logval("left", ((int)now.left));
#endif
		;
		/* merge: .(goto)(60, 56, 60) */
		reached[0][56] = 1;
		;
		/* merge: sampled = (sampled|2)(60, 57, 60) */
		reached[0][57] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|2);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 29: // STATE 57 - model.pml:33 - [sampled = (sampled|2)] (0:60:1 - 3)
		IfNotBlocked
		reached[0][57] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|2);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 30: // STATE 58 - model.pml:34 - [right = 0] (0:65:2 - 1)
		IfNotBlocked
		reached[0][58] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.right);
		now.right = 0;
#ifdef VAR_RANGES
		logval("right", ((int)now.right));
#endif
		;
		/* merge: .(goto)(65, 61, 65) */
		reached[0][61] = 1;
		;
		/* merge: sampled = (sampled|4)(65, 62, 65) */
		reached[0][62] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|4);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 31: // STATE 59 - model.pml:34 - [right = 1] (0:65:2 - 1)
		IfNotBlocked
		reached[0][59] = 1;
		(trpt+1)->bup.ovals = grab_ints(2);
		(trpt+1)->bup.ovals[0] = ((int)now.right);
		now.right = 1;
#ifdef VAR_RANGES
		logval("right", ((int)now.right));
#endif
		;
		/* merge: .(goto)(65, 61, 65) */
		reached[0][61] = 1;
		;
		/* merge: sampled = (sampled|4)(65, 62, 65) */
		reached[0][62] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|4);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 2 */
	case 32: // STATE 62 - model.pml:35 - [sampled = (sampled|4)] (0:65:1 - 3)
		IfNotBlocked
		reached[0][62] = 1;
		(trpt+1)->bup.oval = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|4);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		_m = 3; goto P999; /* 0 */
	case 33: // STATE 63 - model.pml:36 - [dust = 0] (0:82:6 - 1)
		IfNotBlocked
		reached[0][63] = 1;
		(trpt+1)->bup.ovals = grab_ints(6);
		(trpt+1)->bup.ovals[0] = ((int)dust);
		dust = 0;
#ifdef VAR_RANGES
		logval("dust", ((int)dust));
#endif
		;
		/* merge: .(goto)(82, 66, 82) */
		reached[0][66] = 1;
		;
		/* merge: sampled = (sampled|8)(82, 67, 82) */
		reached[0][67] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|8);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		/* merge: .(goto)(82, 70, 82) */
		reached[0][70] = 1;
		;
		/* merge: assert((sampled==15))(82, 71, 82) */
		reached[0][71] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: previous = state(82, 72, 82) */
		reached[0][72] = 1;
		(trpt+1)->bup.ovals[2] = now.previous;
		now.previous = now.state;
#ifdef VAR_RANGES
		logval("previous", now.previous);
#endif
		;
		/* merge: emitted = 0(82, 73, 82) */
		reached[0][73] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.emitted);
		now.emitted = 0;
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: start_timer = 0(82, 74, 82) */
		reached[0][74] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: done = 0(82, 75, 82) */
		reached[0][75] = 1;
		(trpt+1)->bup.ovals[5] = ((int)now.done);
		now.done = 0;
#ifdef VAR_RANGES
		logval("done", ((int)now.done));
#endif
		;
		_m = 3; goto P999; /* 8 */
	case 34: // STATE 64 - model.pml:36 - [dust = 1] (0:82:6 - 1)
		IfNotBlocked
		reached[0][64] = 1;
		(trpt+1)->bup.ovals = grab_ints(6);
		(trpt+1)->bup.ovals[0] = ((int)dust);
		dust = 1;
#ifdef VAR_RANGES
		logval("dust", ((int)dust));
#endif
		;
		/* merge: .(goto)(82, 66, 82) */
		reached[0][66] = 1;
		;
		/* merge: sampled = (sampled|8)(82, 67, 82) */
		reached[0][67] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|8);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		/* merge: .(goto)(82, 70, 82) */
		reached[0][70] = 1;
		;
		/* merge: assert((sampled==15))(82, 71, 82) */
		reached[0][71] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: previous = state(82, 72, 82) */
		reached[0][72] = 1;
		(trpt+1)->bup.ovals[2] = now.previous;
		now.previous = now.state;
#ifdef VAR_RANGES
		logval("previous", now.previous);
#endif
		;
		/* merge: emitted = 0(82, 73, 82) */
		reached[0][73] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.emitted);
		now.emitted = 0;
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: start_timer = 0(82, 74, 82) */
		reached[0][74] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: done = 0(82, 75, 82) */
		reached[0][75] = 1;
		(trpt+1)->bup.ovals[5] = ((int)now.done);
		now.done = 0;
#ifdef VAR_RANGES
		logval("done", ((int)now.done));
#endif
		;
		_m = 3; goto P999; /* 8 */
	case 35: // STATE 67 - model.pml:37 - [sampled = (sampled|8)] (0:82:5 - 3)
		IfNotBlocked
		reached[0][67] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.sampled);
		now.sampled = (((int)now.sampled)|8);
#ifdef VAR_RANGES
		logval("sampled", ((int)now.sampled));
#endif
		;
		/* merge: .(goto)(82, 70, 82) */
		reached[0][70] = 1;
		;
		/* merge: assert((sampled==15))(82, 71, 82) */
		reached[0][71] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: previous = state(82, 72, 82) */
		reached[0][72] = 1;
		(trpt+1)->bup.ovals[1] = now.previous;
		now.previous = now.state;
#ifdef VAR_RANGES
		logval("previous", now.previous);
#endif
		;
		/* merge: emitted = 0(82, 73, 82) */
		reached[0][73] = 1;
		(trpt+1)->bup.ovals[2] = ((int)now.emitted);
		now.emitted = 0;
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: start_timer = 0(82, 74, 82) */
		reached[0][74] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: done = 0(82, 75, 82) */
		reached[0][75] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.done);
		now.done = 0;
#ifdef VAR_RANGES
		logval("done", ((int)now.done));
#endif
		;
		_m = 3; goto P999; /* 6 */
	case 36: // STATE 71 - model.pml:66 - [assert((sampled==15))] (0:82:4 - 3)
		IfNotBlocked
		reached[0][71] = 1;
		spin_assert((((int)now.sampled)==15), "(sampled==15)", II, tt, t);
		/* merge: previous = state(82, 72, 82) */
		reached[0][72] = 1;
		(trpt+1)->bup.ovals = grab_ints(4);
		(trpt+1)->bup.ovals[0] = now.previous;
		now.previous = now.state;
#ifdef VAR_RANGES
		logval("previous", now.previous);
#endif
		;
		/* merge: emitted = 0(82, 73, 82) */
		reached[0][73] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.emitted);
		now.emitted = 0;
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: start_timer = 0(82, 74, 82) */
		reached[0][74] = 1;
		(trpt+1)->bup.ovals[2] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: done = 0(82, 75, 82) */
		reached[0][75] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.done);
		now.done = 0;
#ifdef VAR_RANGES
		logval("done", ((int)now.done));
#endif
		;
		_m = 3; goto P999; /* 4 */
	case 37: // STATE 76 - model.pml:74 - [(!(right))] (91:0:1 - 1)
		IfNotBlocked
		reached[0][76] = 1;
		if (!( !(((int)now.right))))
			continue;
		/* merge: side = RightOpen(91, 77, 91) */
		reached[0][77] = 1;
		(trpt+1)->bup.oval = now.side;
		now.side = 3;
#ifdef VAR_RANGES
		logval("side", now.side);
#endif
		;
		/* merge: .(goto)(91, 83, 91) */
		reached[0][83] = 1;
		;
		/* merge: assert(((side==RightOpen)==!(right)))(91, 84, 91) */
		reached[0][84] = 1;
		spin_assert(((now.side==3)== !(((int)now.right))), "((side==3)== !(right))", II, tt, t);
		/* merge: assert(((side==LeftOpen)==(right&&!(left))))(91, 85, 91) */
		reached[0][85] = 1;
		spin_assert(((now.side==2)==(((int)now.right)&& !(((int)now.left)))), "((side==2)==(right&& !(left)))", II, tt, t);
		/* merge: assert(((side==SidesBlocked)==(right&&left)))(91, 86, 91) */
		reached[0][86] = 1;
		spin_assert(((now.side==1)==(((int)now.right)&&((int)now.left))), "((side==1)==(right&&left))", II, tt, t);
		_m = 3; goto P999; /* 5 */
	case 38: // STATE 78 - model.pml:75 - [((right&&!(left)))] (91:0:1 - 1)
		IfNotBlocked
		reached[0][78] = 1;
		if (!((((int)now.right)&& !(((int)now.left)))))
			continue;
		/* merge: side = LeftOpen(91, 79, 91) */
		reached[0][79] = 1;
		(trpt+1)->bup.oval = now.side;
		now.side = 2;
#ifdef VAR_RANGES
		logval("side", now.side);
#endif
		;
		/* merge: .(goto)(91, 83, 91) */
		reached[0][83] = 1;
		;
		/* merge: assert(((side==RightOpen)==!(right)))(91, 84, 91) */
		reached[0][84] = 1;
		spin_assert(((now.side==3)== !(((int)now.right))), "((side==3)== !(right))", II, tt, t);
		/* merge: assert(((side==LeftOpen)==(right&&!(left))))(91, 85, 91) */
		reached[0][85] = 1;
		spin_assert(((now.side==2)==(((int)now.right)&& !(((int)now.left)))), "((side==2)==(right&& !(left)))", II, tt, t);
		/* merge: assert(((side==SidesBlocked)==(right&&left)))(91, 86, 91) */
		reached[0][86] = 1;
		spin_assert(((now.side==1)==(((int)now.right)&&((int)now.left))), "((side==1)==(right&&left))", II, tt, t);
		_m = 3; goto P999; /* 5 */
	case 39: // STATE 80 - model.pml:76 - [((right&&left))] (91:0:1 - 1)
		IfNotBlocked
		reached[0][80] = 1;
		if (!((((int)now.right)&&((int)now.left))))
			continue;
		/* merge: side = SidesBlocked(91, 81, 91) */
		reached[0][81] = 1;
		(trpt+1)->bup.oval = now.side;
		now.side = 1;
#ifdef VAR_RANGES
		logval("side", now.side);
#endif
		;
		/* merge: .(goto)(91, 83, 91) */
		reached[0][83] = 1;
		;
		/* merge: assert(((side==RightOpen)==!(right)))(91, 84, 91) */
		reached[0][84] = 1;
		spin_assert(((now.side==3)== !(((int)now.right))), "((side==3)== !(right))", II, tt, t);
		/* merge: assert(((side==LeftOpen)==(right&&!(left))))(91, 85, 91) */
		reached[0][85] = 1;
		spin_assert(((now.side==2)==(((int)now.right)&& !(((int)now.left)))), "((side==2)==(right&& !(left)))", II, tt, t);
		/* merge: assert(((side==SidesBlocked)==(right&&left)))(91, 86, 91) */
		reached[0][86] = 1;
		spin_assert(((now.side==1)==(((int)now.right)&&((int)now.left))), "((side==1)==(right&&left))", II, tt, t);
		_m = 3; goto P999; /* 5 */
	case 40: // STATE 84 - model.pml:78 - [assert(((side==RightOpen)==!(right)))] (0:91:0 - 4)
		IfNotBlocked
		reached[0][84] = 1;
		spin_assert(((now.side==3)== !(((int)now.right))), "((side==3)== !(right))", II, tt, t);
		/* merge: assert(((side==LeftOpen)==(right&&!(left))))(91, 85, 91) */
		reached[0][85] = 1;
		spin_assert(((now.side==2)==(((int)now.right)&& !(((int)now.left)))), "((side==2)==(right&& !(left)))", II, tt, t);
		/* merge: assert(((side==SidesBlocked)==(right&&left)))(91, 86, 91) */
		reached[0][86] = 1;
		spin_assert(((now.side==1)==(((int)now.right)&&((int)now.left))), "((side==1)==(right&&left))", II, tt, t);
		_m = 3; goto P999; /* 2 */
	case 41: // STATE 87 - model.pml:83 - [((remaining>0))] (104:0:1 - 1)
		IfNotBlocked
		reached[0][87] = 1;
		if (!((((int)now.remaining)>0)))
			continue;
		/* merge: remaining = (remaining-1)(0, 88, 104) */
		reached[0][88] = 1;
		(trpt+1)->bup.oval = ((int)now.remaining);
		now.remaining = (((int)now.remaining)-1);
#ifdef VAR_RANGES
		logval("remaining", ((int)now.remaining));
#endif
		;
		/* merge: .(goto)(0, 92, 104) */
		reached[0][92] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 42: // STATE 93 - model.pml:86 - [((elapsed!=6))] (100:0:1 - 1)
		IfNotBlocked
		reached[0][93] = 1;
		if (!((((int)now.elapsed)!=6)))
			continue;
		/* merge: elapsed = (elapsed+1)(0, 94, 100) */
		reached[0][94] = 1;
		(trpt+1)->bup.oval = ((int)now.elapsed);
		now.elapsed = (((int)now.elapsed)+1);
#ifdef VAR_RANGES
		logval("elapsed", ((int)now.elapsed));
#endif
		;
		_m = 3; goto P999; /* 1 */
	case 43: // STATE 95 - model.pml:88 - [((elapsed==5))] (207:0:3 - 1)
		IfNotBlocked
		reached[0][95] = 1;
		if (!((((int)now.elapsed)==5)))
			continue;
		/* merge: done = 1(207, 96, 207) */
		reached[0][96] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = ((int)now.done);
		now.done = 1;
#ifdef VAR_RANGES
		logval("done", ((int)now.done));
#endif
		;
		/* merge: elapsed = 6(207, 97, 207) */
		reached[0][97] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.elapsed);
		now.elapsed = 6;
#ifdef VAR_RANGES
		logval("elapsed", ((int)now.elapsed));
#endif
		;
		/* merge: .(goto)(207, 101, 207) */
		reached[0][101] = 1;
		;
		/* merge: .(goto)(207, 105, 207) */
		reached[0][105] = 1;
		;
		/* merge: assert((done==((previous!=Forward)&&(remaining==0))))(207, 106, 207) */
		reached[0][106] = 1;
		spin_assert((((int)now.done)==((now.previous!=14)&&(((int)now.remaining)==0))), "(done==((previous!=14)&&(remaining==0)))", II, tt, t);
		/* merge: guards = (((((((((((((((previous==Forward)&&!(front))+((previous==Forward)&&front))+((previous==Stopping)&&!(done)))+(((previous==Stopping)&&done)&&(side==RightOpen)))+(((previous==Stopping)&&done)&&(side==LeftOpen)))+(((previous==Stopping)&&done)&&(side==SidesBlocked)))+((previous==Backing)&&!(done)))+(((previous==Backing)&&done)&&(side==SidesBlocked)))+(((previous==Backing)&&done)&&(side==RightOpen)))+(((previous==Backing)&&done)&&(side==LeftOpen)))+((previous==TurningRight)&&!(done)))+((previous==TurningRight)&&done))+((previous==TurningLeft)&&!(done)))+((previous==TurningLeft)&&done))(207, 107, 207) */
		reached[0][107] = 1;
		(trpt+1)->bup.ovals[2] = ((int)now.guards);
		now.guards = (((((((((((((((now.previous==14)&& !(((int)now.front)))+((now.previous==14)&&((int)now.front)))+((now.previous==13)&& !(((int)now.done))))+(((now.previous==13)&&((int)now.done))&&(now.side==3)))+(((now.previous==13)&&((int)now.done))&&(now.side==2)))+(((now.previous==13)&&((int)now.done))&&(now.side==1)))+((now.previous==12)&& !(((int)now.done))))+(((now.previous==12)&&((int)now.done))&&(now.side==1)))+(((now.previous==12)&&((int)now.done))&&(now.side==3)))+(((now.previous==12)&&((int)now.done))&&(now.side==2)))+((now.previous==11)&& !(((int)now.done))))+((now.previous==11)&&((int)now.done)))+((now.previous==10)&& !(((int)now.done))))+((now.previous==10)&&((int)now.done)));
#ifdef VAR_RANGES
		logval("guards", ((int)now.guards));
#endif
		;
		/* merge: assert((guards==1))(207, 108, 207) */
		reached[0][108] = 1;
		spin_assert((((int)now.guards)==1), "(guards==1)", II, tt, t);
		_m = 3; goto P999; /* 7 */
	case 44: // STATE 99 - model.pml:88 - [(1)] (207:0:1 - 1)
		IfNotBlocked
		reached[0][99] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(207, 101, 207) */
		reached[0][101] = 1;
		;
		/* merge: .(goto)(207, 105, 207) */
		reached[0][105] = 1;
		;
		/* merge: assert((done==((previous!=Forward)&&(remaining==0))))(207, 106, 207) */
		reached[0][106] = 1;
		spin_assert((((int)now.done)==((now.previous!=14)&&(((int)now.remaining)==0))), "(done==((previous!=14)&&(remaining==0)))", II, tt, t);
		/* merge: guards = (((((((((((((((previous==Forward)&&!(front))+((previous==Forward)&&front))+((previous==Stopping)&&!(done)))+(((previous==Stopping)&&done)&&(side==RightOpen)))+(((previous==Stopping)&&done)&&(side==LeftOpen)))+(((previous==Stopping)&&done)&&(side==SidesBlocked)))+((previous==Backing)&&!(done)))+(((previous==Backing)&&done)&&(side==SidesBlocked)))+(((previous==Backing)&&done)&&(side==RightOpen)))+(((previous==Backing)&&done)&&(side==LeftOpen)))+((previous==TurningRight)&&!(done)))+((previous==TurningRight)&&done))+((previous==TurningLeft)&&!(done)))+((previous==TurningLeft)&&done))(207, 107, 207) */
		reached[0][107] = 1;
		(trpt+1)->bup.oval = ((int)now.guards);
		now.guards = (((((((((((((((now.previous==14)&& !(((int)now.front)))+((now.previous==14)&&((int)now.front)))+((now.previous==13)&& !(((int)now.done))))+(((now.previous==13)&&((int)now.done))&&(now.side==3)))+(((now.previous==13)&&((int)now.done))&&(now.side==2)))+(((now.previous==13)&&((int)now.done))&&(now.side==1)))+((now.previous==12)&& !(((int)now.done))))+(((now.previous==12)&&((int)now.done))&&(now.side==1)))+(((now.previous==12)&&((int)now.done))&&(now.side==3)))+(((now.previous==12)&&((int)now.done))&&(now.side==2)))+((now.previous==11)&& !(((int)now.done))))+((now.previous==11)&&((int)now.done)))+((now.previous==10)&& !(((int)now.done))))+((now.previous==10)&&((int)now.done)));
#ifdef VAR_RANGES
		logval("guards", ((int)now.guards));
#endif
		;
		/* merge: assert((guards==1))(207, 108, 207) */
		reached[0][108] = 1;
		spin_assert((((int)now.guards)==1), "(guards==1)", II, tt, t);
		_m = 3; goto P999; /* 5 */
	case 45: // STATE 103 - model.pml:89 - [(1)] (207:0:1 - 1)
		IfNotBlocked
		reached[0][103] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(207, 105, 207) */
		reached[0][105] = 1;
		;
		/* merge: assert((done==((previous!=Forward)&&(remaining==0))))(207, 106, 207) */
		reached[0][106] = 1;
		spin_assert((((int)now.done)==((now.previous!=14)&&(((int)now.remaining)==0))), "(done==((previous!=14)&&(remaining==0)))", II, tt, t);
		/* merge: guards = (((((((((((((((previous==Forward)&&!(front))+((previous==Forward)&&front))+((previous==Stopping)&&!(done)))+(((previous==Stopping)&&done)&&(side==RightOpen)))+(((previous==Stopping)&&done)&&(side==LeftOpen)))+(((previous==Stopping)&&done)&&(side==SidesBlocked)))+((previous==Backing)&&!(done)))+(((previous==Backing)&&done)&&(side==SidesBlocked)))+(((previous==Backing)&&done)&&(side==RightOpen)))+(((previous==Backing)&&done)&&(side==LeftOpen)))+((previous==TurningRight)&&!(done)))+((previous==TurningRight)&&done))+((previous==TurningLeft)&&!(done)))+((previous==TurningLeft)&&done))(207, 107, 207) */
		reached[0][107] = 1;
		(trpt+1)->bup.oval = ((int)now.guards);
		now.guards = (((((((((((((((now.previous==14)&& !(((int)now.front)))+((now.previous==14)&&((int)now.front)))+((now.previous==13)&& !(((int)now.done))))+(((now.previous==13)&&((int)now.done))&&(now.side==3)))+(((now.previous==13)&&((int)now.done))&&(now.side==2)))+(((now.previous==13)&&((int)now.done))&&(now.side==1)))+((now.previous==12)&& !(((int)now.done))))+(((now.previous==12)&&((int)now.done))&&(now.side==1)))+(((now.previous==12)&&((int)now.done))&&(now.side==3)))+(((now.previous==12)&&((int)now.done))&&(now.side==2)))+((now.previous==11)&& !(((int)now.done))))+((now.previous==11)&&((int)now.done)))+((now.previous==10)&& !(((int)now.done))))+((now.previous==10)&&((int)now.done)));
#ifdef VAR_RANGES
		logval("guards", ((int)now.guards));
#endif
		;
		/* merge: assert((guards==1))(207, 108, 207) */
		reached[0][108] = 1;
		spin_assert((((int)now.guards)==1), "(guards==1)", II, tt, t);
		_m = 3; goto P999; /* 4 */
	case 46: // STATE 106 - model.pml:91 - [assert((done==((previous!=Forward)&&(remaining==0))))] (0:207:1 - 5)
		IfNotBlocked
		reached[0][106] = 1;
		spin_assert((((int)now.done)==((now.previous!=14)&&(((int)now.remaining)==0))), "(done==((previous!=14)&&(remaining==0)))", II, tt, t);
		/* merge: guards = (((((((((((((((previous==Forward)&&!(front))+((previous==Forward)&&front))+((previous==Stopping)&&!(done)))+(((previous==Stopping)&&done)&&(side==RightOpen)))+(((previous==Stopping)&&done)&&(side==LeftOpen)))+(((previous==Stopping)&&done)&&(side==SidesBlocked)))+((previous==Backing)&&!(done)))+(((previous==Backing)&&done)&&(side==SidesBlocked)))+(((previous==Backing)&&done)&&(side==RightOpen)))+(((previous==Backing)&&done)&&(side==LeftOpen)))+((previous==TurningRight)&&!(done)))+((previous==TurningRight)&&done))+((previous==TurningLeft)&&!(done)))+((previous==TurningLeft)&&done))(207, 107, 207) */
		reached[0][107] = 1;
		(trpt+1)->bup.oval = ((int)now.guards);
		now.guards = (((((((((((((((now.previous==14)&& !(((int)now.front)))+((now.previous==14)&&((int)now.front)))+((now.previous==13)&& !(((int)now.done))))+(((now.previous==13)&&((int)now.done))&&(now.side==3)))+(((now.previous==13)&&((int)now.done))&&(now.side==2)))+(((now.previous==13)&&((int)now.done))&&(now.side==1)))+((now.previous==12)&& !(((int)now.done))))+(((now.previous==12)&&((int)now.done))&&(now.side==1)))+(((now.previous==12)&&((int)now.done))&&(now.side==3)))+(((now.previous==12)&&((int)now.done))&&(now.side==2)))+((now.previous==11)&& !(((int)now.done))))+((now.previous==11)&&((int)now.done)))+((now.previous==10)&& !(((int)now.done))))+((now.previous==10)&&((int)now.done)));
#ifdef VAR_RANGES
		logval("guards", ((int)now.guards));
#endif
		;
		/* merge: assert((guards==1))(207, 108, 207) */
		reached[0][108] = 1;
		spin_assert((((int)now.guards)==1), "(guards==1)", II, tt, t);
		_m = 3; goto P999; /* 2 */
	case 47: // STATE 109 - model.pml:110 - [(((previous==Forward)&&!(front)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][109] = 1;
		if (!(((now.previous==14)&& !(((int)now.front)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 48: // STATE 110 - model.pml:41 - [transition = 1] (0:219:5 - 1)
		IfNotBlocked
		reached[0][110] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 1;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 14(219, 111, 219) */
		reached[0][111] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 14;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 9(219, 112, 219) */
		reached[0][112] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 9;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 113, 219) */
		reached[0][113] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 114, 219) */
		reached[0][114] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 49: // STATE 116 - model.pml:111 - [(((previous==Forward)&&front))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][116] = 1;
		if (!(((now.previous==14)&&((int)now.front))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 50: // STATE 117 - model.pml:41 - [transition = 2] (0:219:5 - 1)
		IfNotBlocked
		reached[0][117] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 2;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 13(219, 118, 219) */
		reached[0][118] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 13;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 8(219, 119, 219) */
		reached[0][119] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 8;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 120, 219) */
		reached[0][120] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 121, 219) */
		reached[0][121] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 51: // STATE 123 - model.pml:112 - [(((previous==Stopping)&&!(done)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][123] = 1;
		if (!(((now.previous==13)&& !(((int)now.done)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 52: // STATE 124 - model.pml:41 - [transition = 3] (0:219:5 - 1)
		IfNotBlocked
		reached[0][124] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 3;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 13(219, 125, 219) */
		reached[0][125] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 13;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 8(219, 126, 219) */
		reached[0][126] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 8;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 127, 219) */
		reached[0][127] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 128, 219) */
		reached[0][128] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 53: // STATE 130 - model.pml:113 - [((((previous==Stopping)&&done)&&(side==RightOpen)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][130] = 1;
		if (!((((now.previous==13)&&((int)now.done))&&(now.side==3))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 54: // STATE 131 - model.pml:41 - [transition = 4] (0:219:5 - 1)
		IfNotBlocked
		reached[0][131] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 4;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 11(219, 132, 219) */
		reached[0][132] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 11;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 6(219, 133, 219) */
		reached[0][133] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 6;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 134, 219) */
		reached[0][134] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 135, 219) */
		reached[0][135] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 55: // STATE 137 - model.pml:114 - [((((previous==Stopping)&&done)&&(side==LeftOpen)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][137] = 1;
		if (!((((now.previous==13)&&((int)now.done))&&(now.side==2))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 56: // STATE 138 - model.pml:41 - [transition = 5] (0:219:5 - 1)
		IfNotBlocked
		reached[0][138] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 5;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 10(219, 139, 219) */
		reached[0][139] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 10;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 5(219, 140, 219) */
		reached[0][140] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 5;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 141, 219) */
		reached[0][141] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 142, 219) */
		reached[0][142] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 57: // STATE 144 - model.pml:115 - [((((previous==Stopping)&&done)&&(side==SidesBlocked)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][144] = 1;
		if (!((((now.previous==13)&&((int)now.done))&&(now.side==1))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 58: // STATE 145 - model.pml:41 - [transition = 6] (0:219:5 - 1)
		IfNotBlocked
		reached[0][145] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 6;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 12(219, 146, 219) */
		reached[0][146] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 12;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 7(219, 147, 219) */
		reached[0][147] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 7;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 148, 219) */
		reached[0][148] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 149, 219) */
		reached[0][149] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 59: // STATE 151 - model.pml:116 - [(((previous==Backing)&&!(done)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][151] = 1;
		if (!(((now.previous==12)&& !(((int)now.done)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 60: // STATE 152 - model.pml:41 - [transition = 7] (0:219:5 - 1)
		IfNotBlocked
		reached[0][152] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 7;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 12(219, 153, 219) */
		reached[0][153] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 12;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 7(219, 154, 219) */
		reached[0][154] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 7;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 155, 219) */
		reached[0][155] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 156, 219) */
		reached[0][156] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 61: // STATE 158 - model.pml:117 - [((((previous==Backing)&&done)&&(side==SidesBlocked)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][158] = 1;
		if (!((((now.previous==12)&&((int)now.done))&&(now.side==1))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 62: // STATE 159 - model.pml:41 - [transition = 8] (0:219:5 - 1)
		IfNotBlocked
		reached[0][159] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 8;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 12(219, 160, 219) */
		reached[0][160] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 12;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 7(219, 161, 219) */
		reached[0][161] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 7;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 162, 219) */
		reached[0][162] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 163, 219) */
		reached[0][163] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 63: // STATE 165 - model.pml:118 - [((((previous==Backing)&&done)&&(side==RightOpen)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][165] = 1;
		if (!((((now.previous==12)&&((int)now.done))&&(now.side==3))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 64: // STATE 166 - model.pml:41 - [transition = 9] (0:219:5 - 1)
		IfNotBlocked
		reached[0][166] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 9;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 11(219, 167, 219) */
		reached[0][167] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 11;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 6(219, 168, 219) */
		reached[0][168] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 6;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 169, 219) */
		reached[0][169] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 170, 219) */
		reached[0][170] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 65: // STATE 172 - model.pml:119 - [((((previous==Backing)&&done)&&(side==LeftOpen)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][172] = 1;
		if (!((((now.previous==12)&&((int)now.done))&&(now.side==2))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 66: // STATE 173 - model.pml:41 - [transition = 10] (0:219:5 - 1)
		IfNotBlocked
		reached[0][173] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 10;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 10(219, 174, 219) */
		reached[0][174] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 10;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 5(219, 175, 219) */
		reached[0][175] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 5;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 1(219, 176, 219) */
		reached[0][176] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 1;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 177, 219) */
		reached[0][177] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 67: // STATE 179 - model.pml:120 - [(((previous==TurningRight)&&!(done)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][179] = 1;
		if (!(((now.previous==11)&& !(((int)now.done)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 68: // STATE 180 - model.pml:41 - [transition = 11] (0:219:5 - 1)
		IfNotBlocked
		reached[0][180] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 11;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 11(219, 181, 219) */
		reached[0][181] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 11;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 6(219, 182, 219) */
		reached[0][182] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 6;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 183, 219) */
		reached[0][183] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 184, 219) */
		reached[0][184] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 69: // STATE 186 - model.pml:121 - [(((previous==TurningRight)&&done))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][186] = 1;
		if (!(((now.previous==11)&&((int)now.done))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 70: // STATE 187 - model.pml:41 - [transition = 12] (0:219:5 - 1)
		IfNotBlocked
		reached[0][187] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 12;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 14(219, 188, 219) */
		reached[0][188] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 14;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 9(219, 189, 219) */
		reached[0][189] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 9;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 190, 219) */
		reached[0][190] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 191, 219) */
		reached[0][191] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 71: // STATE 193 - model.pml:122 - [(((previous==TurningLeft)&&!(done)))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][193] = 1;
		if (!(((now.previous==10)&& !(((int)now.done)))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 72: // STATE 194 - model.pml:41 - [transition = 13] (0:219:5 - 1)
		IfNotBlocked
		reached[0][194] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 13;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 10(219, 195, 219) */
		reached[0][195] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 10;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 5(219, 196, 219) */
		reached[0][196] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 5;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 197, 219) */
		reached[0][197] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 198, 219) */
		reached[0][198] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 73: // STATE 200 - model.pml:123 - [(((previous==TurningLeft)&&done))] (0:0:0 - 1)
		IfNotBlocked
		reached[0][200] = 1;
		if (!(((now.previous==10)&&((int)now.done))))
			continue;
		_m = 3; goto P999; /* 0 */
	case 74: // STATE 201 - model.pml:41 - [transition = 14] (0:219:5 - 1)
		IfNotBlocked
		reached[0][201] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.transition);
		now.transition = 14;
#ifdef VAR_RANGES
		logval("transition", ((int)now.transition));
#endif
		;
		/* merge: state = 14(219, 202, 219) */
		reached[0][202] = 1;
		(trpt+1)->bup.ovals[1] = now.state;
		now.state = 14;
#ifdef VAR_RANGES
		logval("state", now.state);
#endif
		;
		/* merge: command = 9(219, 203, 219) */
		reached[0][203] = 1;
		(trpt+1)->bup.ovals[2] = now.command;
		now.command = 9;
#ifdef VAR_RANGES
		logval("command", now.command);
#endif
		;
		/* merge: start_timer = 0(219, 204, 219) */
		reached[0][204] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.start_timer);
		now.start_timer = 0;
#ifdef VAR_RANGES
		logval("start_timer", ((int)now.start_timer));
#endif
		;
		/* merge: emitted = (emitted+1)(219, 205, 219) */
		reached[0][205] = 1;
		(trpt+1)->bup.ovals[4] = ((int)now.emitted);
		now.emitted = (((int)now.emitted)+1);
#ifdef VAR_RANGES
		logval("emitted", ((int)now.emitted));
#endif
		;
		/* merge: .(goto)(219, 208, 219) */
		reached[0][208] = 1;
		;
		/* merge: assert((emitted==1))(219, 209, 219) */
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 6 */
	case 75: // STATE 209 - model.pml:127 - [assert((emitted==1))] (0:219:0 - 15)
		IfNotBlocked
		reached[0][209] = 1;
		spin_assert((((int)now.emitted)==1), "(emitted==1)", II, tt, t);
		_m = 3; goto P999; /* 0 */
	case 76: // STATE 210 - model.pml:129 - [((previous==Forward))] (227:0:0 - 1)
		IfNotBlocked
		reached[0][210] = 1;
		if (!((now.previous==14)))
			continue;
		/* merge: assert((((front&&(state==Stopping))&&start_timer)||((!(front)&&(state==Forward))&&!(start_timer))))(0, 211, 227) */
		reached[0][211] = 1;
		spin_assert((((((int)now.front)&&(now.state==13))&&((int)now.start_timer))||(( !(((int)now.front))&&(now.state==14))&& !(((int)now.start_timer)))), "(((front&&(state==13))&&start_timer)||(( !(front)&&(state==14))&& !(start_timer)))", II, tt, t);
		/* merge: .(goto)(0, 220, 227) */
		reached[0][220] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 77: // STATE 212 - model.pml:132 - [(((previous!=Forward)&&!(done)))] (227:0:0 - 1)
		IfNotBlocked
		reached[0][212] = 1;
		if (!(((now.previous!=14)&& !(((int)now.done)))))
			continue;
		/* merge: assert(((state==previous)&&!(start_timer)))(0, 213, 227) */
		reached[0][213] = 1;
		spin_assert(((now.state==now.previous)&& !(((int)now.start_timer))), "((state==previous)&& !(start_timer))", II, tt, t);
		/* merge: .(goto)(0, 220, 227) */
		reached[0][220] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 78: // STATE 214 - model.pml:133 - [((((previous==Stopping)||(previous==Backing))&&done))] (227:0:0 - 1)
		IfNotBlocked
		reached[0][214] = 1;
		if (!((((now.previous==13)||(now.previous==12))&&((int)now.done))))
			continue;
		/* merge: assert(start_timer)(227, 215, 227) */
		reached[0][215] = 1;
		spin_assert(((int)now.start_timer), "start_timer", II, tt, t);
		/* merge: assert((((!(right)&&(state==TurningRight))||((right&&!(left))&&(state==TurningLeft)))||((right&&left)&&(state==Backing))))(227, 216, 227) */
		reached[0][216] = 1;
		spin_assert(((( !(((int)now.right))&&(now.state==11))||((((int)now.right)&& !(((int)now.left)))&&(now.state==10)))||((((int)now.right)&&((int)now.left))&&(now.state==12))), "((( !(right)&&(state==11))||((right&& !(left))&&(state==10)))||((right&&left)&&(state==12)))", II, tt, t);
		/* merge: .(goto)(0, 220, 227) */
		reached[0][220] = 1;
		;
		_m = 3; goto P999; /* 3 */
	case 79: // STATE 217 - model.pml:138 - [((((previous==TurningRight)||(previous==TurningLeft))&&done))] (227:0:0 - 1)
		IfNotBlocked
		reached[0][217] = 1;
		if (!((((now.previous==11)||(now.previous==10))&&((int)now.done))))
			continue;
		/* merge: assert(((state==Forward)&&!(start_timer)))(0, 218, 227) */
		reached[0][218] = 1;
		spin_assert(((now.state==14)&& !(((int)now.start_timer))), "((state==14)&& !(start_timer))", II, tt, t);
		/* merge: .(goto)(0, 220, 227) */
		reached[0][220] = 1;
		;
		_m = 3; goto P999; /* 2 */
	case 80: // STATE 221 - model.pml:143 - [(start_timer)] (239:0:5 - 1)
		IfNotBlocked
		reached[0][221] = 1;
		if (!(((int)now.start_timer)))
			continue;
		/* merge: assert((remaining==0))(239, 222, 239) */
		reached[0][222] = 1;
		spin_assert((((int)now.remaining)==0), "(remaining==0)", II, tt, t);
		/* merge: elapsed = 0(239, 223, 239) */
		reached[0][223] = 1;
		(trpt+1)->bup.ovals = grab_ints(5);
		(trpt+1)->bup.ovals[0] = ((int)now.elapsed);
		now.elapsed = 0;
#ifdef VAR_RANGES
		logval("elapsed", ((int)now.elapsed));
#endif
		;
		/* merge: remaining = 5(239, 224, 239) */
		reached[0][224] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.remaining);
		now.remaining = 5;
#ifdef VAR_RANGES
		logval("remaining", ((int)now.remaining));
#endif
		;
		/* merge: .(goto)(239, 228, 239) */
		reached[0][228] = 1;
		;
		/* merge: direction = command(239, 229, 239) */
		reached[0][229] = 1;
		(trpt+1)->bup.ovals[2] = now.direction;
		now.direction = now.command;
#ifdef VAR_RANGES
		logval("direction", now.direction);
#endif
		;
		/* merge: avoiding = (command!=GoForward)(239, 230, 239) */
		reached[0][230] = 1;
		(trpt+1)->bup.ovals[3] = ((int)now.avoiding);
		now.avoiding = (now.command!=9);
#ifdef VAR_RANGES
		logval("avoiding", ((int)now.avoiding));
#endif
		;
		/* merge: assert(((((((state==Forward)&&(command==GoForward))||((state==Stopping)&&(command==Stop)))||((state==Backing)&&(command==GoBackward)))||((state==TurningRight)&&(command==TurnRight)))||((state==TurningLeft)&&(command==TurnLeft))))(239, 231, 239) */
		reached[0][231] = 1;
		spin_assert(((((((now.state==14)&&(now.command==9))||((now.state==13)&&(now.command==8)))||((now.state==12)&&(now.command==7)))||((now.state==11)&&(now.command==6)))||((now.state==10)&&(now.command==5))), "((((((state==14)&&(command==9))||((state==13)&&(command==8)))||((state==12)&&(command==7)))||((state==11)&&(command==6)))||((state==10)&&(command==5)))", II, tt, t);
		/* merge: assert(((direction==command)&&(avoiding==(state!=Forward))))(239, 232, 239) */
		reached[0][232] = 1;
		spin_assert(((now.direction==now.command)&&(((int)now.avoiding)==(now.state!=14))), "((direction==command)&&(avoiding==(state!=14)))", II, tt, t);
		/* merge: assert(((((state==Forward)&&(elapsed==6))&&(remaining==0))||(((state!=Forward)&&(elapsed<5))&&(remaining==(5-elapsed)))))(239, 233, 239) */
		reached[0][233] = 1;
		spin_assert(((((now.state==14)&&(((int)now.elapsed)==6))&&(((int)now.remaining)==0))||(((now.state!=14)&&(((int)now.elapsed)<5))&&(((int)now.remaining)==(5-((int)now.elapsed))))), "((((state==14)&&(elapsed==6))&&(remaining==0))||(((state!=14)&&(elapsed<5))&&(remaining==(5-elapsed))))", II, tt, t);
		/* merge: printf('T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\\n',transition,previous,front,left,right,done,state,command,elapsed,remaining)(239, 234, 239) */
		reached[0][234] = 1;
		Printf("T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\n", ((int)now.transition), now.previous, ((int)now.front), ((int)now.left), ((int)now.right), ((int)now.done), now.state, now.command, ((int)now.elapsed), ((int)now.remaining));
		/* merge: stable = 1(239, 235, 239) */
		reached[0][235] = 1;
		(trpt+1)->bup.ovals[4] = ((int)stable);
		stable = 1;
#ifdef VAR_RANGES
		logval("stable", ((int)stable));
#endif
		;
		/* merge: assert((transition!=255))(239, 236, 239) */
		reached[0][236] = 1;
		spin_assert((((int)now.transition)!=255), "(transition!=255)", II, tt, t);
		/* merge: assert((state!=0))(239, 237, 239) */
		reached[0][237] = 1;
		spin_assert((now.state!=0), "(state!=0)", II, tt, t);
		/* merge: .(goto)(0, 240, 239) */
		reached[0][240] = 1;
		;
		_m = 3; goto P999; /* 14 */
	case 81: // STATE 226 - model.pml:147 - [(1)] (239:0:3 - 1)
		IfNotBlocked
		reached[0][226] = 1;
		if (!(1))
			continue;
		/* merge: .(goto)(239, 228, 239) */
		reached[0][228] = 1;
		;
		/* merge: direction = command(239, 229, 239) */
		reached[0][229] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = now.direction;
		now.direction = now.command;
#ifdef VAR_RANGES
		logval("direction", now.direction);
#endif
		;
		/* merge: avoiding = (command!=GoForward)(239, 230, 239) */
		reached[0][230] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.avoiding);
		now.avoiding = (now.command!=9);
#ifdef VAR_RANGES
		logval("avoiding", ((int)now.avoiding));
#endif
		;
		/* merge: assert(((((((state==Forward)&&(command==GoForward))||((state==Stopping)&&(command==Stop)))||((state==Backing)&&(command==GoBackward)))||((state==TurningRight)&&(command==TurnRight)))||((state==TurningLeft)&&(command==TurnLeft))))(239, 231, 239) */
		reached[0][231] = 1;
		spin_assert(((((((now.state==14)&&(now.command==9))||((now.state==13)&&(now.command==8)))||((now.state==12)&&(now.command==7)))||((now.state==11)&&(now.command==6)))||((now.state==10)&&(now.command==5))), "((((((state==14)&&(command==9))||((state==13)&&(command==8)))||((state==12)&&(command==7)))||((state==11)&&(command==6)))||((state==10)&&(command==5)))", II, tt, t);
		/* merge: assert(((direction==command)&&(avoiding==(state!=Forward))))(239, 232, 239) */
		reached[0][232] = 1;
		spin_assert(((now.direction==now.command)&&(((int)now.avoiding)==(now.state!=14))), "((direction==command)&&(avoiding==(state!=14)))", II, tt, t);
		/* merge: assert(((((state==Forward)&&(elapsed==6))&&(remaining==0))||(((state!=Forward)&&(elapsed<5))&&(remaining==(5-elapsed)))))(239, 233, 239) */
		reached[0][233] = 1;
		spin_assert(((((now.state==14)&&(((int)now.elapsed)==6))&&(((int)now.remaining)==0))||(((now.state!=14)&&(((int)now.elapsed)<5))&&(((int)now.remaining)==(5-((int)now.elapsed))))), "((((state==14)&&(elapsed==6))&&(remaining==0))||(((state!=14)&&(elapsed<5))&&(remaining==(5-elapsed))))", II, tt, t);
		/* merge: printf('T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\\n',transition,previous,front,left,right,done,state,command,elapsed,remaining)(239, 234, 239) */
		reached[0][234] = 1;
		Printf("T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\n", ((int)now.transition), now.previous, ((int)now.front), ((int)now.left), ((int)now.right), ((int)now.done), now.state, now.command, ((int)now.elapsed), ((int)now.remaining));
		/* merge: stable = 1(239, 235, 239) */
		reached[0][235] = 1;
		(trpt+1)->bup.ovals[2] = ((int)stable);
		stable = 1;
#ifdef VAR_RANGES
		logval("stable", ((int)stable));
#endif
		;
		/* merge: assert((transition!=255))(239, 236, 239) */
		reached[0][236] = 1;
		spin_assert((((int)now.transition)!=255), "(transition!=255)", II, tt, t);
		/* merge: assert((state!=0))(239, 237, 239) */
		reached[0][237] = 1;
		spin_assert((now.state!=0), "(state!=0)", II, tt, t);
		/* merge: .(goto)(0, 240, 239) */
		reached[0][240] = 1;
		;
		_m = 3; goto P999; /* 11 */
	case 82: // STATE 229 - model.pml:149 - [direction = command] (0:239:3 - 3)
		IfNotBlocked
		reached[0][229] = 1;
		(trpt+1)->bup.ovals = grab_ints(3);
		(trpt+1)->bup.ovals[0] = now.direction;
		now.direction = now.command;
#ifdef VAR_RANGES
		logval("direction", now.direction);
#endif
		;
		/* merge: avoiding = (command!=GoForward)(239, 230, 239) */
		reached[0][230] = 1;
		(trpt+1)->bup.ovals[1] = ((int)now.avoiding);
		now.avoiding = (now.command!=9);
#ifdef VAR_RANGES
		logval("avoiding", ((int)now.avoiding));
#endif
		;
		/* merge: assert(((((((state==Forward)&&(command==GoForward))||((state==Stopping)&&(command==Stop)))||((state==Backing)&&(command==GoBackward)))||((state==TurningRight)&&(command==TurnRight)))||((state==TurningLeft)&&(command==TurnLeft))))(239, 231, 239) */
		reached[0][231] = 1;
		spin_assert(((((((now.state==14)&&(now.command==9))||((now.state==13)&&(now.command==8)))||((now.state==12)&&(now.command==7)))||((now.state==11)&&(now.command==6)))||((now.state==10)&&(now.command==5))), "((((((state==14)&&(command==9))||((state==13)&&(command==8)))||((state==12)&&(command==7)))||((state==11)&&(command==6)))||((state==10)&&(command==5)))", II, tt, t);
		/* merge: assert(((direction==command)&&(avoiding==(state!=Forward))))(239, 232, 239) */
		reached[0][232] = 1;
		spin_assert(((now.direction==now.command)&&(((int)now.avoiding)==(now.state!=14))), "((direction==command)&&(avoiding==(state!=14)))", II, tt, t);
		/* merge: assert(((((state==Forward)&&(elapsed==6))&&(remaining==0))||(((state!=Forward)&&(elapsed<5))&&(remaining==(5-elapsed)))))(239, 233, 239) */
		reached[0][233] = 1;
		spin_assert(((((now.state==14)&&(((int)now.elapsed)==6))&&(((int)now.remaining)==0))||(((now.state!=14)&&(((int)now.elapsed)<5))&&(((int)now.remaining)==(5-((int)now.elapsed))))), "((((state==14)&&(elapsed==6))&&(remaining==0))||(((state!=14)&&(elapsed<5))&&(remaining==(5-elapsed))))", II, tt, t);
		/* merge: printf('T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\\n',transition,previous,front,left,right,done,state,command,elapsed,remaining)(239, 234, 239) */
		reached[0][234] = 1;
		Printf("T%d prev=%e f=%d l=%d r=%d done=%d state=%e cmd=%e elapsed=%d remaining=%d\n", ((int)now.transition), now.previous, ((int)now.front), ((int)now.left), ((int)now.right), ((int)now.done), now.state, now.command, ((int)now.elapsed), ((int)now.remaining));
		/* merge: stable = 1(239, 235, 239) */
		reached[0][235] = 1;
		(trpt+1)->bup.ovals[2] = ((int)stable);
		stable = 1;
#ifdef VAR_RANGES
		logval("stable", ((int)stable));
#endif
		;
		/* merge: assert((transition!=255))(239, 236, 239) */
		reached[0][236] = 1;
		spin_assert((((int)now.transition)!=255), "(transition!=255)", II, tt, t);
		/* merge: assert((state!=0))(239, 237, 239) */
		reached[0][237] = 1;
		spin_assert((now.state!=0), "(state!=0)", II, tt, t);
		/* merge: .(goto)(0, 240, 239) */
		reached[0][240] = 1;
		;
		_m = 3; goto P999; /* 9 */
	case 83: // STATE 242 - model.pml:166 - [-end-] (0:0:0 - 1)
		IfNotBlocked
		reached[0][242] = 1;
		if (!delproc(1, II)) continue;
		_m = 3; goto P999; /* 0 */
	case  _T5:	/* np_ */
		if (!((!(trpt->o_pm&4) && !(trpt->tau&128))))
			continue;
		/* else fall through */
	case  _T2:	/* true */
		_m = 3; goto P999;
#undef rand
	}

