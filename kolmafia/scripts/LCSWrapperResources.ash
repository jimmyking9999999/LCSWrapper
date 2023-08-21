
script "LCSWrapperResources.ash";
// LCSWrapper Resources - Everything used in the run that isn't called in the actual run itself
/* IoTMs currently in here (Ctrl + F to jump):

--pocketmeteors
--alicearmy
--clipart
--monkeypaw
--bottledgenie
--cargopants
--augustscepter

Note: Not all iotms supported are in this file. Currently in-process of transferring everything over =)
*/

/* Days since last effect system rework: 76 */

void refresh() {
  visit_url("main.php");
}

// Following snippet from c2t_hccs <3 //

boolean get_effect(effect effe){

	if(get_property("lcs_excluded_buffs").to_lower_case().contains_text(effe.to_lower_case()) || get_property("lcs_excluded_buffs").contains_text(effe.to_int())){
		print(`Skipping effect {effe} based on user preference!`, "orange");
		return false;
	}


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

// --pocketmeteors
void meteor_shower(){
  // If we have the skill but not the meteor showered effect, as well as saber/shower uses remaining
  if((have_skill($skill[Meteor Lore])) && (get_property("_meteorShowerUses") < 5) && (get_property('_saberForceUses').to_int() < 5) && (!have_effect($effect[Meteor Showered]).to_boolean())){
  familiar pre_shower_fam = my_familiar();
  use_familiar($familiar[none]);

  // Prevents wanderers
  foreach it in $items[Kramco Sausage-o-Matic&trade;, &quot;I Voted!&quot; sticker]{
    if(equipped_amount(it) != 0){
      maximize(`-equip {it}`, false);
    }
  }

  int prev_adv = turns_played();
  string meteorsaber = "skill Meteor Shower; skill Use the Force";

  cli_execute("checkpoint");
  maximize("mainstat, -10 damage aura, equip fourth of may cosplay saber, -equip i voted, -equip Kramco Sausage-o-Matic", false);

  if(have_effect($effect[Feeling Lost]).to_boolean()){ // Tries to fight a barrel mimic if you have feeling lost 
      visit_url("barrel.php");
      foreach slotnum in $strings[00, 01, 02, 10, 11, 12, 20, 21, 22]{
        if(!have_effect($effect[Meteor Showered]).to_boolean()){
          visit_url(`choice.php?whichchoice=1099&pwd={my_hash()}&option=1&slot={slotnum}`);
          if(current_round() != 0){
            run_combat(meteorsaber);
            run_choice(1);
          }
      }
    }
  } else {

    if(can_adventure($location[thugnderdome]) && (item_amount($item[Bitchin' Meatcar]).to_boolean() || item_amount($item[Desert Bus Pass]).to_boolean())){
      visit_url("adventure.php?snarfblat=46");
      refresh();
      run_combat(meteorsaber);
      run_choice(3);
      
    } else {
      // Noob cave
      visit_url("adventure.php?snarfblat=240");
      refresh();
      run_combat(meteorsaber);
      run_choice(3);

    }
  }

  use_familiar(pre_shower_fam);
  cli_execute("outfit checkpoint");

  // Uses a thrall + outfit combo to equip a stick-knife if we have one in our inventory that needs 150 musc to equip

  if(item_amount($item[Stick-knife of Loathing]).to_boolean() && have_skill($skill[Bind Undead Elbow Macaroni])){
    use_skill(1, $skill[Bind Undead Elbow Macaroni]);

    foreach i, o_name in get_custom_outfits(){
      if(o_name.to_lower_case() == "stick-knife"){
          outfit(o_name);
      }
    }
    
    if(!equipped_amount($item[Stick-knife of Loathing]).to_boolean()){
    foreach x, outfit_name in get_custom_outfits()
      foreach x,piece in outfit_pieces(outfit_name)

        if(piece.contains_text("Stick-Knife of Loathing")){
          outfit(outfit_name);
        } 
    }
  }

    if(prev_adv != turns_played()){
      abort("Acquiring meteor showered took a turn, which isn't supposed to happen. Please DM Jimmyking with a log <3");
    }
  }
}

void newline() {
  print(" ");
}

string is_plural(int number){
	if(number == 1){
		return "";
	}
	return "s";
}


int get_all_freekills(){
	int total_freekills;

	if(get_property("lcs_skip_freekills").to_boolean()){
		return 1;
	}

	if(have_skill($skill[Shattering Punch]).to_boolean()){
		total_freekills += 3 - get_property("_shatteringPunchUsed").to_int();
	}

	if(available_amount($item[Lil' Doctor&trade; bag]).to_boolean()){
		total_freekills += 3 - get_property("_chestXRayUsed").to_int();
	}

	total_freekills += available_amount($item[Groveling Gravel]).to_int();

	if(have_skill($skill[Gingerbread Mob Hit]) && get_property("_gingerbreadMobHitUsed").to_boolean()){
		total_freekills++;
	}

	total_freekills += get_property("shockingLickCharges").to_int();

	if(total_freekills == 0){
		total_freekills++;
	}

	return total_freekills;
}



// --clipart
boolean clip_art(item it) {
	if (!have_skill($skill[summon clip art]) || get_property("tomeSummons").to_int() >= 3){
		return false;
	}

	if(item_amount(it) > 0){
	  return true;
  	}
	
	print(`Casting clip art for item {it}!`, "teal");
	return retrieve_item(it);
}

// --bottledgenie | --monkeypaw
boolean wish_effect(effect effe){
	print(`Trying to wish for effect: {effe}`, "teal");
	if(have_effect(effe).to_boolean())
		return true;

	if(get_property("lcs_excluded_buffs").to_lower_case().contains_text(effe.to_lower_case()) || get_property("lcs_excluded_buffs").contains_text(effe.to_int())){
		print(`Skipping effect {effe} based on user preference!`, "orange");
		return false;
	}

	if(available_amount($item[Cursed Monkey's Paw]).to_boolean()){

		boolean equipped_paw;

		foreach it in $slots[Acc1, acc2, acc3]{
			if(equipped_item(it) == $item[Cursed Monkey's Paw]){
				equip(it, $item[None]);
				equipped_paw = true;
			}
		}
		visit_url("main.php?action=cmonk&pwd");
		run_choice(1, "wish=$" + effe);

		visit_url("main.php");

		if(equipped_paw){
			cli_execute("equip Cursed Monkey's Paw");
		}


		if(have_effect(effe).to_boolean())
			return true;
	}


  if(item_amount($item[Genie Bottle]).to_boolean() || item_amount($item[Pocket Wish]).to_boolean()){
    cli_execute(`genie effect {effe}`);
  }

	return have_effect(effe).to_boolean();
}

// --alicearmy
boolean alice_army_snack(effect soda){
	item snack = substring(soda.default, 6).to_item();

	if(!get_property("grimoire3Summons").to_boolean() && have_skill($skill[Summon Alice's Army Cards])){
		use_skill(1, $skill[Summon Alice's Army Cards]);
		buy($coinmaster[Game Shoppe Snacks], 1, snack);
	}
	if(item_amount(snack).to_boolean()){
		use(1, snack);
	}

	return(have_effect(soda).to_boolean());
}

// --cargopants
boolean cargo_effect(effect eff){

	if(have_effect(eff).to_boolean()){
		return true;
	}

	if(available_amount($item[Cargo Cultist Shorts]).to_boolean() && !get_property('_cargoPocketEmptied').to_boolean()){
		switch(eff) {
			case $effect[Rictus of Yeg]:
				cli_execute("cargo item Yeg's Motel Toothbrush");
				use(1, $item[Yeg's Motel Toothbrush]);
			break;

			case $effect[Sigils of Yeg]:
				cli_execute("cargo item Yeg's Motel Hand Soap");
				use(1, $item[Yeg's Motel Hand Soap]);
			break;

			default:
				cli_execute(`cargo effect {eff}`);
			break;
		}
	}

	return have_effect(eff).to_boolean();
}

//--augustscepter
boolean august_scepter(int day){
	visit_url(`runskillz.php?action=Skillz&whichskill={7451 + day}&targetplayer=${my_id()}&pwd=&quantity=1`);
	// TODO fix this when mafia has support lol

	return true;
}

boolean get_shadow_waters(){
	if(item_amount($item[closed-circuit pay phone]).to_boolean() && !have_effect($effect[Shadow Waters]).to_boolean()){	
		if(get_property("questRufus") == "step1"){
			use(1, $item[closed-circuit pay phone]);
			run_choice(1);
		}

		if(item_amount($item[Rufus's shadow lodestone]).to_boolean()){
			string choicebefore = get_property("choiceAdventure1500");
			set_property("choiceAdventure1500", "2");
			adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, "abot");
			set_property("choiceAdventure1500", choicebefore);
		}
	}
	return have_effect($effect[Shadow Waters]).to_boolean();
}

string is_an(string it){
  if($strings[a, e, i, o, u] contains substring(it, 0, 1)){
    return "n";
  }

  return "";
}

boolean pull_item(item it, string condition){
  if(available_amount(it).to_boolean()){
    return true;
  }

  if(pulls_remaining() == 0){
	return false;
  }

  print(`Pulling a{is_an(it.to_string())} {it}!`, "teal");

  if(condition == ""){
	if(!storage_amount(it).to_boolean()){
		buy_using_storage(1, it);
	}

	take_storage(1,it);
  } else {
    if(cli_execute(`ashq if({condition});`).to_boolean()){ // Don't look >.>
		if(!storage_amount(it).to_boolean()){
			buy_using_storage(1, it);
		}

		take_storage(1,it);
    }
  }

  return available_amount(it).to_boolean();
}

string test_number_to_name(int testnum){

	switch(testnum){
		default:
			abort("Invalid test number!");
		case 1: return "hp"; 
		case 2: return "mus"; 
		case 3: return "mys"; 
		case 4: return "mox"; 
		case 5: return "fam_weight"; 
		case 6: return "weapon_damage"; 
		case 7: return "spell_damage"; 
		case 8: return "non_combat"; 
		case 9: return "item"; 
		case 10: return "hot_res"; 
		case 11: return "coil_wire";
		case 30: return "science_vessel";

	}

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

// Following snippet from AutoHCCS.ash <3 // 
int scrape_test_turns(int whichtest) {
  buffer page = visit_url("council.php");
  string teststr = "name=option value="+ whichtest +">";
  if (contains_text(page, teststr)) {
    int chars = 140; //chars to look ahead
    string pagestr = substring(page, page.index_of(teststr)+length(teststr), page.index_of(teststr)+length(teststr)+chars);
    string advstr = substring(pagestr, pagestr.index_of("(")+1, pagestr.index_of("(")+3);
    advstr = replace_string(advstr, " ", ""); //removes whitespace, if the test is < 10 adv
    return to_int(advstr);
  } else {
    abort(`We didn't find specified test on the council page! (Test {test_number_to_name(whichtest)})`);
	return -1;
  }
}



boolean gain_adventures(int advs_to_gain){
	while(my_adventures() < (advs_to_gain + 1)){ // +1 for combo/any advs afterwards
		// Sources of advs: Smith's tome food, Perfect Drinks, Astral Pilsners, Numberology, Borrowed Time, CBB food (t1/2s), Meteoreo, Meadeorite VIP Hot Dogs and Booze, Boxing Daycare
		if(item_amount($item[Astral Pilsner]).to_boolean()){
			if(!have_effect($effect[Ode to Booze]).to_boolean()){
				use_skill($skill[The Ode to Booze]);
			}

			drink(1, $item[Astral Pilsner]);
			// drink(min(ceil(advs_to_gain / 11.0).to_int(), item_amount($item[Astral Pilsner])), $item[Astral Pilsner]);
		}



	}

	return my_adventures() > advs_to_gain;
}

void cs_test(int testnum){

	print(`Expected turns for test {test_number_to_name(testnum)}: {test_turns(testnum)} turns`, "lime");
	
	print(`(Looking at the council.php text gives us a turn amount of {scrape_test_turns(testnum)})`, "teal");
	if(scrape_test_turns(testnum) != test_turns(testnum) && test_turns(testnum) != 1){
		print("Uh-oh. The estimated script turn amount and council turn amount are different! We'll continue and use the latter", "red");
		waitq(2);
	}

	visit_url("council.php");	
	if(scrape_test_turns(testnum) <= get_property(`lcs_turn_threshold_{test_number_to_name(testnum)}`).to_int()){
		gain_adventures(scrape_test_turns(testnum));
		visit_url(`choice.php?whichchoice=1089&option={testnum}&pwd`);
	} else {
		abort("Manually do the test, see if you can optimize any further, then ping me your turn threshold (if needed) ^w^");
	}
}

// TODO synthesis oh no
boolean synthesis_effect(effect eff){
	if(have_effect(eff).to_boolean()){
		return true;
	}

	if(!have_skill($skill[Sweet Synthesis])){
		return false;
	}



	if(have_skill($skill[Summon crimbo candy])){
		use_skill(1, $skill[Summon crimbo candy]);
	}

	return false;
}

familiar current_best_fam(){
	// CS Optimal familiars: CBB (6.6 turns on item%) -> Camel (4 turns on weapon damage, 2 on spell damage) -> Shortest-Order Cook (2 turns on familiar weight) -> Garbage Fire (1-2 turns on familiar weight) -> Sombrero (Stats)
	if(have_familiar($familiar[Cookbookbat]) && !get_property("lcs_skip_cbb").to_boolean() && item_amount($item[Vegetable of Jarlsberg]) < 2){
		return $familiar[Cookbookbat];
	}

	if((have_familiar($familiar[Melodramedary]) && get_property("camelSpit").to_int() < 100) || !have_effect($effect[Spit Upon]).to_boolean() ){
		return $familiar[Melodramedary];
	}

	if(have_familiar($familiar[Garbage Fire]) && (!available_amount($item[burning paper crane]).to_boolean() || item_amount($item[burning newspaper]).to_boolean())){
		return $familiar[Garbage Fire];
	}

	if(have_familiar($familiar[Shorter-Order Cook]) && !item_amount($item[short stack of pancakes]).to_boolean() && !have_effect($effect[Shortly Stacked]).to_boolean()){
		return $familiar[Shorter-Order Cook];
	}

	if(have_familiar($familiar[Artistic Goth Kid])){
		return $familiar[Artistic Goth Kid];
	}

	return $familiar[Hovering Sombrero];

}

effect eff;
boolean no_more_buffs = false;
/* Effects go here, numbered by priority */

string [int] powerlevel_effects = {
    "Glittering Eyelashes",
    "Inscrutable Gaze",
    "Ode to Booze",
    "Saucemastery",
    "Big",
    "Carol of the Thrills",
    "Spirit of Cayenne",
    "Ur-Kel's Aria of Annoyance",
    "Shanty of Superiority",
    "Leash of Linguini",
    "Empathy",
    "Pride of the Puffin",
    "Feeling Nervous",
    "Feeling Excited",
    "Feeling Peaceful",
    "Blood Bubble",
    "Song of Bravado",
    "Disdain of she-who-was",
    "Blood Bond",
    "Bendin' Hell",
    "Triple-Sized",
	"Total Protonic Reversal",
	"drescher's annoying noise",
	"Astral Shell",
	"pasta oneness",
    "END",
};

string [int] mys_effects = {
	"Glittering Eyelashes",
	"Big",
	"Quiet Judgement",
	"Shanty of Superiority",
	"END",
}; 

string [int] mox_effects = {
    "Expert Oiliness",
    "Song of bravado",
    "Blubbered up",
    "Disco state of mind",
    "Mariachi mood",
    "Butt-rock hair",
    "Unrunnable face",
    "Feeling Excited",
    "Quiet Desperation",
    "Stevedave's Shanty of Superiority",
    "The Moxious Madrigal",
    "aMAZing",
    "END",
};

string [int] mus_effects = {
    "Expert Oiliness",
    "Go get 'em, tiger!",
    "Seal clubbing frenzy",
    "Rage of the reindeer",
    "Patience of the tortoise",
    "Disdain of the war snapper",
    "Song of bravado",
    "Quiet determination",
    "Feeling excited",
    "Phorcefullness",
    "END",
};

string [int] hp_effects = {
	"Song of starch",
	"Reptilian fortitude",
	"END",
}; 

string [int] item_effects = {
	"Ode to Booze",
	"Nearly All-Natural",
	"Steely-Eyed Squint",
	"Fat Leon's Phat Loot Lyric",
	"Singer's Faithful Ocelot",
	"Crunching Leaves",
	"El Aroma de Salsa",
	"Spice haze",
	"Lantern-Charged",
	"Wizard Sight",
	"Glowing Hands",
	"Ermine Eyes",
	"Spitting Rhymes",
	"Feeling Lost",
	"END",
}; 

string [int] hot_res_effects = {
    "Elemental Saucesphere",
    "Astral Shell",
    "Leash of Linguini",
    "Empathy",
    "Amazing",
    "Feeling Peaceful",
    "Hot-headed",
	"Rainbow Vaccine",
    "END",
};

string [int] fam_weight_effects = {
    "Ode to Booze", // Hmmm...
	"Robot Friends",
    "Empathy",
    "Leash of Linguini",
    "Blood Bond",
    "Billiards Belligerence",
    "Loyal as a Rock",
    "Party Soundtrack",
    "END",
};
string [int] non_combat_effects = {
    "Smooth Movements",
    "The Sonata of Sneakiness",
    "A Rose by any Other Material",
    "Leash of Linguini",
    "Empathy",
    "Feeling Lonely",
    "Feeling Sneaky",
    "Throwing Some Shade",
    "Silent Running",
	"Invisible Avatar",
    "END",
};

string [int] weapon_damage_effects = {
	"Bow-Legged Swagger",
	"Cowrruption",
	"Billiards Belligerence",
	"Scowl of the auk",
	"Tenacity of the snapper",
	"Frenzied, bloody",
	"Disdain of the war snapper",
	"Lack of body-building",
	"Carol of the Bulls",
	"Song of the North",
	"Rage of the Reindeer",
	"Imported Strength",
	"Feeling punchy",
	"Engorged weapon",
	"Pronounced Potency",
	"Ham-fisted",
	"END",
};

string [int] spell_damage_effects = {
	"We're all made of starfish",
	"Jackasses' Symphony of Destruction",
	"Cowrruption",
	"Arched Eyebrow of the Archmage",
	"AA-Charged",
	"Carol of the Hells",
	"Spirit of Peppermint",
	"Song of Sauce",
	"Mental A-cue-ity",
	"Imported Strength",
	"AAA-Charged",
	"D-Charged",
	"Concentration",
	"END",
}; 





/// TEST ///




string [string] test_effects = {
	"We're all made of starfish":"",
	"Jackasses' Symphony of Destruction":"cast Jackasses' Symphony of Destruction",
	"Arched Eyebrow of the Archmage":"cast Arched Eyebrow of the Archmage",
	"Carol of the Hells":"",
	"Spirit of Peppermint":"",
	"Song of Sauce":"",
	"Mental A-cue-ity":"",
	"END":"",
}; 











/// TEST END ///


boolean test_test_turns(int test_number, string eff_to_check) {
	if(eff_to_check == "END"){
		abort(`We failed to reach the target! Only managed to get the test down to {test_turns(test_number)} turns!`);
	}	

	if(have_effect(eff).to_boolean()){
		return true;
	}


	if(contains_text(eff_to_check, "WISH")){
    string eff_to_wish = replace_all(create_matcher("WISH", eff_to_check), "");
		return wish_effect(eff_to_wish.to_effect());
	}

	
	if(contains_text(eff_to_check, "CLI_EX")){
		eff_to_check = replace_all(create_matcher("CLI_EX", eff_to_check), "");
		string[int] cli_command = split_string(eff_to_check, "IF_COND");

		if(cli_command[1].to_boolean()){
			cli_execute(cli_command[0]);
			return true;
		}

	return false;
	
		
	}

	eff = eff_to_check.to_effect();
		
		if(get_effect(eff)){
			print(`Successfully obtained effect {eff}, {scrape_test_turns(1)} turns left to save!`, "lime");
			print("");
			return true;
		} else {
			print("");
		} 
	
	return false;
}


void buff_up(int test){

string[int] effects;
	switch(test){
		default: 
			abort(`Test {test} is an invalid selection!`);

		case 1:
			effects = hp_effects;
		break;

		case 2:
			effects = mus_effects;
		break;

		case 3:
			effects = mys_effects;
		break;

		case 4:
			effects = mox_effects;
		break;

		case 5:
			effects = fam_weight_effects;
		break;

		case 6:
			effects = weapon_damage_effects;
		break;

		case 7:
			effects = spell_damage_effects;
		break;

		case 8:
			effects = non_combat_effects;
		break;

		case 9:
			effects = item_effects;
		break;

		case 10:
			effects = hot_res_effects;
		break;
		
	}

	foreach it in effects{
		if(effects[it] == "END"){
			abort(`We failed to reach the target! Only managed to get the test down to {test_turns(test)} turns!`);
		}

		eff = effects[it].to_effect();
		if(!have_effect(eff).to_boolean()){

			if(get_effect(eff)){
				print(`Successfully obtained effect {eff}, {scrape_test_turns(test)} turns left to save!`, "lime");
				print("");
				break;
			} else {
				print("");
			} 
		}
	} 

}






// Following snippet from Pantocinchlus <3 //

void get_modtrace(string mod, boolean exact) {
	string html_output = cli_execute_output("modtrace " + mod);
	float val, total_val = 0;
 
	string header = substring(html_output, index_of(html_output, "<tr>") + 4, index_of(html_output, "</tr>"));
	string [int] headers;
	string [int] [int] gs = group_string(header, "(>)(.*?)(</td>)");
	int exact_col = -1;
	foreach idx in gs {
		headers[idx] = gs[idx][2];
		if (to_lower_case(headers[idx]) == to_lower_case(mod)) exact_col = idx;			
	}
 
	if (exact && exact_col == -1) {
		print("Could not find exact string match of " + mod, "red");
		return;
	}
 
	if (to_lower_case(mod) == "familiar weight") {
		print("[Familiar Weight] Base weight (" + familiar_weight(my_familiar()) + ")");
		total_val += familiar_weight(my_familiar());
	}
 
	html_output = substring(html_output, index_of(html_output, "</tr>") + 5, index_of(html_output, "</table>"));
	string row, source;
	string [int] row_data;
	int idx_start, idx_end;	
 
	while (html_output.length() > 0) {
		idx_start = index_of(html_output, "<tr>");
		idx_end = index_of(html_output, "</tr>");
		if (idx_start == -1) break;
		row = substring(html_output, idx_start + 4, idx_end);
		row = replace_all(create_matcher("(>)(</td>)", row), ">0</td>");		
		gs = group_string(row, "(>)(.*?)(</td>)");
		foreach idx in gs {
			row_data[idx] = gs[idx][2];
			if (idx > 1) {
				val = row_data[idx].to_float();
				if (val != 0 && idx%2 == 0 && (!exact || (exact && (idx/2 + 1 == exact_col)))) {				
					print("[" + headers[idx/2 + 1] + "] " + row_data[1] + " (" + val + ")");
					total_val += val;
				}	
			}
 
		}		
		html_output = substring(html_output, idx_end + 5);
	}
 
	if (to_lower_case(mod) == "weapon damage") {
		if (have_effect($effect[bow-legged swagger]) > 0) {
			print("[Weapon Damage] Bow-Legged Swagger (" + total_val + ")");
			total_val += total_val;
		}
	} else if (to_lower_case(mod) == "weapon damage percent") {
		if (have_effect($effect[bow-legged swagger]) > 0) {
			print("[Weapon Damage Percent] Bow-Legged Swagger (" + total_val + ")");
			total_val += total_val;
		}
	}
 
	print("Total " + mod + ": " + total_val, "lime");
}
 
void get_modtrace(string mod) {
	get_modtrace(mod, true);
}
 
void get_modtrace(string [int] modifiers, string base_modifier) {
	string html_output = cli_execute_output("modtrace " + base_modifier);
	float val;
	float [string] total_val;
 
	string header = substring(html_output, index_of(html_output, "<tr>") + 4, index_of(html_output, "</tr>"));
	string [int] headers;
	string [int] [int] gs = group_string(header, "(>)(.*?)(</td>)");
	int [int] good_cols; 

	foreach idx in gs {
		headers[idx] = gs[idx][2];
		foreach key in modifiers {
			if (to_lower_case(headers[idx]) == to_lower_case(modifiers[key])) {
				good_cols[idx] = key;
				total_val[headers[idx]] = 0.0;
			}
		}		
	}
 
	if (to_lower_case(base_modifier) == "familiar weight") {
		print("[Familiar Weight] Base weight (" + familiar_weight(my_familiar()) + ")");
		total_val["Familiar Weight"] += familiar_weight(my_familiar());
	}
 
	html_output = substring(html_output, index_of(html_output, "</tr>") + 5, index_of(html_output, "</table>"));
	string row, source;
	string [int] row_data;
	int idx_start, idx_end;	
 
	while (html_output.length() > 0) {
		idx_start = index_of(html_output, "<tr>");
		idx_end = index_of(html_output, "</tr>");
		if (idx_start == -1) break;
		row = substring(html_output, idx_start + 4, idx_end);
		row = replace_all(create_matcher("(>)(</td>)", row), ">0</td>");		
		gs = group_string(row, "(>)(.*?)(</td>)");
		foreach idx in gs {
			row_data[idx] = gs[idx][2];
			if (idx > 1) {
				val = row_data[idx].to_float();
				foreach col in good_cols {
					if (val != 0 && idx%2 == 0 && (idx/2 + 1 == col)) {				
						print("[" + headers[idx/2 + 1] + "] " + row_data[1] + " (" + val + ")");
						total_val[headers[idx/2 + 1]] += val;
					}	
				}
			}
 
		}		
		html_output = substring(html_output, idx_end + 5);
	}
 
	foreach key in modifiers {
		if (to_lower_case(modifiers[key]) == "weapon damage") {
			if (have_effect($effect[bow-legged swagger]) > 0) {
				print("[Weapon Damage] Bow-Legged Swagger (" + total_val["Weapon Damage"] + ")");
				total_val["Weapon Damage"] *= 2;
			}
		} else if (to_lower_case(modifiers[key]) == "weapon damage percent") {
			if (have_effect($effect[bow-legged swagger]) > 0) {
				print("[Weapon Damage Percent] Bow-Legged Swagger (" + total_val["Weapon Damage Percent"] + ")");
				total_val["Weapon Damage Percent"] *= 2;
			}
		}
	}
 
	float total = 0.0;
	foreach key in total_val {
		total += total_val[key];
		print(key + " => " + total_val[key], "teal");
	}	
 
	print("Total " + base_modifier + ": " + total, "lime");
}
 
void get_modtrace(string [int] modifiers) {
	int [int] base_modifiers;
	foreach key in modifiers {
		base_modifiers[key] = 1;
	}
 
	foreach key_this in modifiers {
		foreach key_next in modifiers {
			if (key_this != key_next && contains_text(modifiers[key_this], modifiers[key_next])) {				
				base_modifiers[key_this] = 0;
				break;
			}
		}
	}
 
	foreach key_this in modifiers {
		if (base_modifiers[key_this] == 0) continue;
 
		string [int] modifiers_subset;
		modifiers_subset[key_this] = modifiers[key_this];		
 
		foreach key_next in modifiers {
			if (key_this != key_next && contains_text(modifiers[key_next], modifiers[key_this])) {
				modifiers_subset[key_next] = modifiers[key_next];
			}
		}		
		get_modtrace(modifiers_subset, modifiers[key_this]);
	}
}

string [int] spell_modifiers = {
	0: "Spell Damage Percent",
	1: "Spell Damage",
	2: "Sauce Spell Damage"
};

 
string [int] item_modifiers = {
	0: "Item Drop",
	1: "Booze Drop"
};
