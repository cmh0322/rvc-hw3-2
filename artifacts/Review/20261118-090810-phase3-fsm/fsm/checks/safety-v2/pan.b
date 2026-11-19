	switch (t->back) {
	default: Uerror("bad return move");
	case  0: goto R999; /* nothing to undo */

		 /* PROC Controller */

	case 3: // STATE 2
		;
		now.previous = trpt->bup.ovals[1];
		now.state = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 4: // STATE 9
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 5: // STATE 19
		;
		now.sampled = trpt->bup.ovals[1];
		now.front = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 7: // STATE 19
		;
		now.sampled = trpt->bup.ovals[1];
		now.front = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 8: // STATE 19
		;
		now.sampled = trpt->bup.ovals[1];
		now.front = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 9: // STATE 19
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 10: // STATE 24
		;
		now.sampled = trpt->bup.ovals[1];
		now.left = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 11: // STATE 24
		;
		now.sampled = trpt->bup.ovals[1];
		now.left = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 12: // STATE 24
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 13: // STATE 29
		;
		now.sampled = trpt->bup.ovals[1];
		now.right = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 14: // STATE 29
		;
		now.sampled = trpt->bup.ovals[1];
		now.right = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 15: // STATE 29
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 16: // STATE 34
		;
		now.sampled = trpt->bup.ovals[1];
		dust = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 17: // STATE 34
		;
		now.sampled = trpt->bup.ovals[1];
		dust = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 18: // STATE 34
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 19: // STATE 38
		;
		stable = trpt->bup.oval;
		;
		goto R999;

	case 20: // STATE 75
		;
		now.done = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.emitted = trpt->bup.ovals[2];
		now.previous = trpt->bup.ovals[1];
		now.first_tick = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;

	case 21: // STATE 42
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 22: // STATE 52
		;
		now.sampled = trpt->bup.ovals[1];
		now.front = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;
;
		;
		
	case 24: // STATE 52
		;
		now.sampled = trpt->bup.ovals[1];
		now.front = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 25: // STATE 52
		;
		now.sampled = trpt->bup.ovals[1];
		now.front = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 26: // STATE 52
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 27: // STATE 57
		;
		now.sampled = trpt->bup.ovals[1];
		now.left = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 28: // STATE 57
		;
		now.sampled = trpt->bup.ovals[1];
		now.left = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 29: // STATE 57
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 30: // STATE 62
		;
		now.sampled = trpt->bup.ovals[1];
		now.right = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 31: // STATE 62
		;
		now.sampled = trpt->bup.ovals[1];
		now.right = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 2);
		goto R999;

	case 32: // STATE 62
		;
		now.sampled = trpt->bup.oval;
		;
		goto R999;

	case 33: // STATE 75
		;
		now.done = trpt->bup.ovals[5];
		now.start_timer = trpt->bup.ovals[4];
		now.emitted = trpt->bup.ovals[3];
		now.previous = trpt->bup.ovals[2];
		now.sampled = trpt->bup.ovals[1];
		dust = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 6);
		goto R999;

	case 34: // STATE 75
		;
		now.done = trpt->bup.ovals[5];
		now.start_timer = trpt->bup.ovals[4];
		now.emitted = trpt->bup.ovals[3];
		now.previous = trpt->bup.ovals[2];
		now.sampled = trpt->bup.ovals[1];
		dust = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 6);
		goto R999;

	case 35: // STATE 75
		;
		now.done = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.emitted = trpt->bup.ovals[2];
		now.previous = trpt->bup.ovals[1];
		now.sampled = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;

	case 36: // STATE 75
		;
		now.done = trpt->bup.ovals[3];
		now.start_timer = trpt->bup.ovals[2];
		now.emitted = trpt->bup.ovals[1];
		now.previous = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 4);
		goto R999;

	case 37: // STATE 77
		;
		now.side = trpt->bup.oval;
		;
		goto R999;

	case 38: // STATE 79
		;
		now.side = trpt->bup.oval;
		;
		goto R999;

	case 39: // STATE 81
		;
		now.side = trpt->bup.oval;
		;
		goto R999;
;
		
	case 40: // STATE 84
		goto R999;

	case 41: // STATE 88
		;
		now.remaining = trpt->bup.oval;
		;
		goto R999;

	case 42: // STATE 94
		;
		now.elapsed = trpt->bup.oval;
		;
		goto R999;

	case 43: // STATE 107
		;
		now.guards = trpt->bup.ovals[2];
		now.elapsed = trpt->bup.ovals[1];
		now.done = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 44: // STATE 107
		;
		now.guards = trpt->bup.oval;
		;
		goto R999;

	case 45: // STATE 107
		;
		now.guards = trpt->bup.oval;
		;
		goto R999;

	case 46: // STATE 107
		;
		now.guards = trpt->bup.oval;
		;
		goto R999;
;
		;
		
	case 48: // STATE 114
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 50: // STATE 121
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 52: // STATE 128
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 54: // STATE 135
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 56: // STATE 142
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 58: // STATE 149
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 60: // STATE 156
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 62: // STATE 163
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 64: // STATE 170
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 66: // STATE 177
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 68: // STATE 184
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 70: // STATE 191
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 72: // STATE 198
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		;
		
	case 74: // STATE 205
		;
		now.emitted = trpt->bup.ovals[4];
		now.start_timer = trpt->bup.ovals[3];
		now.command = trpt->bup.ovals[2];
		now.state = trpt->bup.ovals[1];
		now.transition = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;
;
		
	case 75: // STATE 209
		goto R999;
;
		
	case 76: // STATE 210
		goto R999;
;
		
	case 77: // STATE 212
		goto R999;
;
		
	case 78: // STATE 214
		goto R999;
;
		
	case 79: // STATE 217
		goto R999;

	case 80: // STATE 235
		;
		stable = trpt->bup.ovals[4];
		now.avoiding = trpt->bup.ovals[3];
		now.direction = trpt->bup.ovals[2];
		now.remaining = trpt->bup.ovals[1];
		now.elapsed = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 5);
		goto R999;

	case 81: // STATE 235
		;
		stable = trpt->bup.ovals[2];
		now.avoiding = trpt->bup.ovals[1];
		now.direction = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 82: // STATE 235
		;
		stable = trpt->bup.ovals[2];
		now.avoiding = trpt->bup.ovals[1];
		now.direction = trpt->bup.ovals[0];
		;
		ungrab_ints(trpt->bup.ovals, 3);
		goto R999;

	case 83: // STATE 242
		;
		p_restor(II);
		;
		;
		goto R999;
	}

