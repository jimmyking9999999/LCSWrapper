// Shamelessly stolen and edited from c2t_hccs LMAO
boolean get_effect(effect effe){

	if (have_effect(effe).to_boolean()){
		return true;
  }

	string default_method = effe.default;

	string temp;
	skill ski;
	item it;
	string [int] spl;


	if (default_method.starts_with("cast ")) {
		spl = default_method.split_string(" ");

		for i from 2 to spl.count() - 1{
			temp += i == 2?spl[i]:` {spl[i]}`;
    }
    
		ski = temp.to_skill();



		if (!have_skill(ski)) {
			print(`We can't get effect {effe}, as we lack {ski}`);
			return false;
		} 

    use_skill(1, ski);

	} else if (default_method.starts_with("use ")) {
		spl = default_method.split_string(" ");

		if (spl[1] == "either") {
			cli_execute(default_method);
			return have_effect(effe).to_boolean();
		}

		for i from 2 to spl.count()-1
			temp += i == 2?spl[i]:` {spl[i]}`;
		it = temp.to_item();

		if (!retrieve_item(it)) {
			print(`We don't have a {it} to get effect {effe}!`);
			return false;
		}

		use(it);

	}
	else {
		cli_execute(default_method);
  }

	return have_effect(effe).to_boolean();
} 

string yip1;
string yip2;
string yip3;
int digits;

string convert_commas(int number) { 
	digits = length(number);
	switch{
		case (digits == 4):
			yip1 = "";
			yip2 = substring(number.to_string(), 0, 1) + ",";
			yip3 = substring(number.to_string(), 1, 4);	
			break;
		case (digits == 5):
			yip1 = "";
			yip2 = substring(number.to_string(), 0, 2) + ",";
			yip3 = substring(number.to_string(), 2, 5);	
			break;
		case (digits == 6):
			yip1 = "";
			yip2 = substring(number.to_string(), 0, 3) + ",";
			yip3 = substring(number.to_string(), 3, 6);	
			break;
		case (digits == 7):
			yip1 = substring(number.to_string(), 0, 1) + ","; 
			yip2 = substring(number.to_string(), 1, 4) + ",";
			yip3 = substring(number.to_string(), 4, 7);			
			break;
		case (digits == 8):
			yip1 = substring(number.to_string(), 0, 2) + ",";
			yip2 = substring(number.to_string(), 2, 5) + ",";
			yip3 = substring(number.to_string(), 5, 8);			
			break;
		case (digits == 9):
			yip1 = substring(number.to_string(), 0, 3) + ",";
			yip2 = substring(number.to_string(), 3, 6) + ",";
			yip3 = substring(number.to_string(), 6, 10);			
			break;

		default:
			yip1 = "";
			yip2 = "";
			yip3 = number;
		}

return yip1 + yip2 + yip3;
}


int test_turns(int test){
	switch (test) {
		default:
		abort("Invalid test number!");

		case 1:
			return 60 - (my_maxhp() - (my_buffedstat($stat[muscle]) + 3)) / 30;
		case 2:
			return 60 - (my_buffedstat($stat[Muscle]) - my_basestat($stat[Muscle])) / 30;
		case 3:
			return 60 - (my_buffedstat($stat[mysticality]) - my_basestat($stat[mysticality])) / 30;
		case 4:
			return 60 - (my_buffedstat($stat[Moxie]) - my_basestat($stat[Moxie])) / 30;
		case 5:
			return 60 - floor((familiar_weight(my_familiar()) + round(numeric_modifier("familiar weight"))) / 5);
		case 6:
			float modifier_1 = numeric_modifier("Weapon Damage");
			float modifier_2 = numeric_modifier("Weapon Damage Percent");
			foreach s in $slots[hat,weapon,off-hand,back,shirt,pants,acc1,acc2,acc3,familiar]
			{
				item it = s.equipped_item();
				if (it.to_slot() != $slot[weapon]) continue;
					int power = it.get_power();
					float addition = to_float(power) * 0.15;
									
				modifier_1 -= addition;
			}
			if ($effect[bow-legged swagger].have_effect() > 0)
			{
				modifier_1 *= 2;
				modifier_2 *= 2;
			}
			return 60 - (floor(modifier_1 / 50 + 0.001) + floor(modifier_2 / 50 + 0.001));

		case 7:
			return 60 - (floor(numeric_modifier("Spell Damage") / 50 + 0.001) + floor(numeric_modifier("Spell Damage Percent") / 50 + 0.001));
		
		case 8:
			int combat_rate_raw = round(numeric_modifier("Combat Rate"));
			int combat_rate_inverse = 0;

			if (combat_rate_raw < 0) combat_rate_inverse = -combat_rate_raw;
			if (combat_rate_inverse > 25) combat_rate_inverse = (combat_rate_inverse - 25) * 5 + 25;
			
			return 60 - (combat_rate_inverse / 5) * 3;

		case 9:
			return 60 - floor(numeric_modifier('Booze Drop') / 15 + 0.001) - floor(numeric_modifier('Item Drop') / 30 + 0.001);
		case 10:
			return 60 - round(numeric_modifier("Hot Resistance"));
		case 11:
			return 60;
	}
}



effect eff;
boolean no_more_buffs = false;
/* Effects go here, numbered by priority */

string [int] powerlevel_effects = {
  1:"Glittering Eyelashes",
  2:"Inscrutable Gaze",
  3:"Ode to Booze",
  4:"Saucemastery",
  5:"Big",
  6:"Carol of the Thrills",
  7:"Spirit of Cayenne",
  8:"Ur-Kel's Aria of Annoyance",
  9:"Shanty of Superiority",
  10:"Leash of Linguini",
  11:"Empathy",
  12:"Pride of the Puffin",
	13:"Feeling Nervous",
  14:"Feeling Excited",
	15:"Feeling Peaceful",
	16:"Blood Bubble",
	17:"Song of Bravado",
	18:"Disdain of she-who-was",
	19:"Blood Bond",
	20:"Bendin' Hell",
	21:"END",
}; 

string [int] mys_effects = {
  1:"Glittering Eyelashes",
  2:"Big",
  3:"Quiet Judgement",
  4:"Shanty of Superiority",
	5:"END",
}; 

string [int] mox_effects = {
  1:"Expert Oiliness",
  2:"Song of bravado",
  3:"Blubbered up",
  4:"Disco state of mind",
  5:"Mariachi mood",
  6:"Butt-rock hair",
	7:"Unrunnable face",
  8:"Feeling Excited",
	9:"END",
}; 

string [int] mus_effects = {
  1:"Expert Oiliness",
  2:"Go get 'em, tiger!",
  3:"Seal clubbing frenzy",
  4:"Rage of the reindeer",
  5:"Patience of the tortoise",
  6:"Disdain of the war snapper",
	7:"Song of bravado",
  8:"Quiet determination",
	9:"Feeling excited",
	10:"END",
}; 

string [int] hp_effects = {
  1:"Song of starch",
  2:"Reptilian fortitude",
	3:"END",
}; 

string [int] item_effects = {
  1:"Ode to Booze",
  2:"Nearly All-Natural",
  3:"Steely-Eyed Squint",
  4:"Fat Leon's Phat Loot Lyric",
  5:"Singer's Faithful Ocelot",
  6:"Crunching Leaves",
  7:"El Aroma de Salsa",
	8:"Spice haze",
  9:"Lantern-Charged",
	10:"Wizard Sight",
	11:"Feeling Lost",
	12:"END",
}; 

string [int] hot_res_effects = {
  1:"Elemental Saucesphere",
  2:"Astral Shell",
  3:"Leash of Linguini",
  4:"Empathy",
  5:"Amazing",
  6:"Feeling Peaceful",
	7:"Hot-headed",
	8:"END",
}; 

string [int] fam_weight_effects = {
  1:"Ode to Booze",
  2:"Empathy",
  3:"Leash of Linguini",
  4:"Blood Bond",
  5:"Billiards Belligerence",
	6:"END",
}; 

string [int] non_combat_effects = {
  1:"Smooth Movements",
  2:"The Sonata of Sneakiness",
  3:"A Rose by any Other Material",
  4:"Leash of Linguini",
  5:"Empathy",
  6:"Feeling Lonely",
	7:"Feeling Sneaky",
  8:"Throwing Some Shade",
	9:"Silent Running",
	10:"END",
}; 

string [int] weapon_damage_effects = {
  1:"Cowrruption",
	2:"Billiards Belligerence",
  3:"Scowl of the auk",
  4:"Tenacity of the snapper",
  5:"Frenzied, bloody",
  6:"Disdain of the war snapper",
	7:"Lack of body-building",
  8:"Carol of the Bulls",
	9:"Song of the North",
	10:"Rage of the Reindeer",
	11:"Song of the North",
	12:"Feeling punchy",
	13:"Engorged weapon",
	14:"Pronounced Potency",
	15:"Ham-fisted",
	16:"END",
}; 

string [int] spell_damage_effects = {
  1:"We're all made of starfish",
  2:"Jackasses' symphony of destruction",
  3:"Cowrruption",
  4:"Arched eyebrow of the archmage",
  5:"AA-Charged",
  6:"Carol of the Hells",
  7:"Spirit of Peppermint",
  8:"Song of Sauce",
	9:"Mental A-cue-ity",
  5:"AAA-Charged",
  5:"D-Charged",
	10:"END",
}; 



void buff_up(int test){

switch (test) {
		default:
		abort("Invalid test number!");

	case 1:
	foreach it in hp_effects{
		if(hp_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(1)} turns!`);
		}

		eff = hp_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(1)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 2:
	foreach it in mus_effects{
		if(mus_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(2)} turns!`);
		}

		eff = mus_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(2)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 3:
	foreach it in mys_effects{
		if(mys_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(3)} turns!`);
		}

		eff = mys_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(3)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 4:
	foreach it in mox_effects{
		if(mox_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(4)} turns!`);
		}

		eff = mox_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(4)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 5:
	foreach it in fam_weight_effects{
		if(fam_weight_effects[it] == "END"){
			print(`We failed to reach the target! Only managed to get the test down to {test_turns(5)} turns!`, "red");
			no_more_buffs = true;
			break;
		}

		eff = fam_weight_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(5)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 6:
		foreach it in weapon_damage_effects{
		if(weapon_damage_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(6)} turns!`);
		}

		eff = weapon_damage_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(6)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 7:
	foreach it in spell_damage_effects{
		if(spell_damage_effects[it] == "END"){
			print(`We failed to reach the target! Only managed to get the test down to {test_turns(7)} turns!`, "red");
			no_more_buffs = true;
			break;
		}

		eff = spell_damage_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(7)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 8:
	foreach it in non_combat_effects{
		if(non_combat_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(8)} turns!`);
		}

		eff = non_combat_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(8)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

	case 9:
		foreach it in item_effects{
		if(item_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(9)} turns!`);
		}

		eff = item_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(9)} turns left to save!`, "lime");
				print("");
				break;
	
			} else {
				print("");

			} 
		}
	} break;

	case 10:
	foreach it in hot_res_effects{
		if(hot_res_effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(10)} turns!`);
		}

		eff = hot_res_effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {test_turns(10)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} break;

}
}
