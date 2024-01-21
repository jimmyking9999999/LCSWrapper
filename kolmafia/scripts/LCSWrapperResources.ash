
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
--lovetunnel
--eagle
--camel
--melf
--witchess
--barrelgod
Note: Not all iotms supported are in this file. Currently in-process of transferring everything over =)
*/

/* Days since last effect system rework: 0 holy crap */

location scaler_zone = 
  get_property("neverendingPartyAlways").to_boolean() ? $location[The Neverending Party]: 
  get_property("stenchAirportAlways").to_boolean() ? $location[Uncle Gator's Country Fun-Time Liquid Waste Sluice]:
  get_property("spookyAirportAlways").to_boolean() ? $location[The Deep Dark Jungle]:
  get_property("hotAirportAlways").to_boolean() ? $location[The SMOOCH Army HQ]:
  get_property("coldAirportAlways").to_boolean() ? $location[VYKEA]:
  get_property("sleazeAirportAlways").to_boolean() ? $location[Sloppy Seconds Diner]:
  $location[Uncle Gator's Country Fun-Time Liquid Waste Sluice];


// Freerun macro to call back on in other macros
string freerun = "if hasskill feel hatred; skill feel hatred; endif; if hasskill snokebomb; skill snokebomb; endif; if hasskill reflex hammer; skill reflex hammer; endif; if hasskill 7301; skill 7301; endif";

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
			temp += i == 2 ? spl[i] : ` {spl[i]}`;
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
		if(default_method.contains_text('cargo')){
			return false;
		}
		cli_execute(default_method);
    }

	return have_effect(effe).to_boolean();
} 


// Todo: Roaring hearth?
boolean equip_stick_knife(){

	if(!available_amount($item[Stick-knife of loathing]).to_boolean() || (my_basestat($stat[Muscle]) < 150 && my_class() != $class[Pastamancer])){
		return false;
	}

	if(equipped_amount($item[Stick-knife of Loathing]).to_boolean()){
		return true;
	}

	if(my_basestat($stat[Muscle]) >= 150){
		equip($slot[Weapon], $item[Stick-knife of Loathing]);
		return have_equipped($item[Stick-knife of Loathing]);
	}

	foreach x, outfit_name in get_custom_outfits(){

		if(outfit_pieces(outfit_name).count() == 1 && !have_equipped($item[Stick-knife of Loathing])){

			if(outfit_pieces(outfit_name)[0] == $item[Stick-knife of Loathing]){
				print(`Outfit '{outfit_name}' has a stick-knife in it! Pulling a stick-knife and trying to equip that outfit...`, "teal");
				if(!item_amount($item[Stick-knife of Loathing]).to_boolean()){
					take_storage(1, $item[Stick-knife of Loathing]);
				}
				use_skill(1, $skill[Bind Undead Elbow Macaroni]);
				outfit(outfit_name);
				break;
			} 
		}
	}

	if(!equipped_amount($item[Stick-knife of Loathing]).to_boolean()){
		print("Uh-oh, you don't have an outfit with a knife in it! Make one after the run finishes!", "red");
		waitq(5);
		return false;
	}

	return have_equipped($item[Stick-knife of Loathing]);
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
  maximize("mainstat, -100 damage aura, equip fourth of may cosplay saber, -equip i voted, -equip Kramco Sausage-o-Matic", false);

  if(have_effect($effect[Feeling Lost]).to_boolean()){ // Tries to fight a barrel mimic if you have feeling lost TODO: Scepter/witcess
      visit_url("barrel.php");
      foreach slotnum in $strings[00, 01, 02, 10, 11, 12, 20, 21, 22]{
        if(!have_effect($effect[Meteor Showered]).to_boolean()){
          visit_url(`choice.php?whichchoice=1099&pwd={my_hash()}&option=1&slot={slotnum}`);
          if(current_round() != 0){
            run_combat(meteorsaber);
            run_choice(1);
          }
      }

	  if(!have_effect($effect[Meteor Showered]).to_boolean()){
		print("We don't have meteor showered after barrels! Try witchess/scepter!", "red");	  }
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
	cli_execute("outfit checkpoint; checkpoint clear");

	equip_stick_knife();

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

	if(have_skill($skill[Gingerbread Mob Hit]) && !get_property("_gingerbreadMobHitUsed").to_boolean()){
		total_freekills++;
	}

	total_freekills += get_property("shockingLickCharges").to_int();

	return (have_familiar($familiar[Trick-or-Treating Tot]) && have_skill($skill[Map the monsters])) ? total_freekills : total_freekills - 1;
}

int get_all_freeruns(){
	int total_freeruns;

	if(have_skill($skill[Snokebomb])){
		total_freeruns += 3 - get_property("_snokebombUsed").to_int();
	}

	if(have_skill($skill[Feel Hatred])){
		total_freeruns += 3 - get_property("_feelHatredUsed").to_int();
	}

	if(equipped_amount($item[latte lovers member's mug]).to_boolean() && get_property("_latteBanishUsed") == "false"){
		total_freeruns++;
	}

	if(equipped_amount($item[Lil' Doctor&trade; bag]).to_boolean()){
		total_freeruns += 3 - get_property("_reflexHammerUsed").to_int();
	}

	return total_freeruns + available_amount($item[Cosmic Bowling Ball]);
	
}

// --clipart
boolean clip_art(item it) {
	if (!have_skill($skill[summon clip art]) || get_property("tomeSummons").to_int() >= 3){
		return false;
	}

	if(item_amount(it) > 0){
	  return true;
  	}

	if(it == $item[Borrowed Time] && get_property("_borrowedTimeUsed") == "true"){
		return false;
	}
	
	print(`Casting clip art for item {it}!`, "teal");
	return retrieve_item(it);
}

// --bottledgenie | --monkeypaw
boolean wish_effect(string eff){
	effect effe = eff.to_effect();

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
boolean alice_army_snack(effect soda, item snack){

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

	if(!available_amount($item[august scepter]).to_boolean() || get_property("_augSkillsCast") == "5"){
		return false;
	}

	if(get_property(`_aug{day}Cast`).to_boolean()){
		return false;
	}

	return use_skill(1, (7451 + day).to_skill());
}

// -catalog
boolean catalog(string type){
	if(!item_amount($item[2002 Mr. Store Catalog]).to_boolean() || get_property("availableMrStore2002Credits") == "0"){
		return false;
	}

	switch(type){
		case "boots":
			if(available_amount($item[red-soled high heels]).to_boolean()){
				return true;
			}

			if(!item_amount($item[Letter from Carrie Bradshaw]).to_boolean()){
				buy($coinmaster[mr. store 2002], 1, $item[Letter from Carrie Bradshaw]);
			}

			visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=11259`);
			run_choice(3);

			maximize("item, booze drop, -equip broken champagne bottle, switch left-hand man", false); 

			return available_amount($item[red-soled high heels]).to_boolean();

		case "rhymes":
			if(have_effect($effect[Spitting Rhymes]).to_boolean()){
				return true;
			}

			buy($coinmaster[mr. store 2002], 1, $item[Loathing Idol Microphone]);
			get_effect($effect[Spitting Rhymes]);

			return have_effect($effect[Spitting Rhymes]).to_boolean();

		case "nellyville":
			if(have_effect($effect[Hot in Herre]).to_boolean()){
				return true;
			}
			
			buy($coinmaster[mr. store 2002], 1, $item[Charter: Nellyville]);
			use(1, $item[charter: nellyville]);

			return have_effect($effect[Hot in Herre]).to_boolean();


		default:
			abort(`Invalid catalog arguments!`);
	}

	return false;
}

// -payphone
boolean get_shadow_waters(){
	// TODO: Preference for fighting the boss, in order to get one extra fam turn
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

//-eagle
boolean eagle_pledge(string loc){
	if(have_effect($effect[Feeling Lost]).to_boolean() || !have_familiar($familiar[Patriotic Eagle]) || get_all_freeruns() == 0){
		return false;
	}

	if(have_effect($effect[Citizen of a Zone]).to_boolean() && visit_url(`desc_effect.php?whicheffect={$effect[Citizen of a Zone].descid}`).to_lower_case().contains_text(loc.to_lower_case())){
		return true;
	}

	familiar pre_pledge_fam = my_familiar();
	cli_execute("checkpoint");
	use_familiar($familiar[Patriotic Eagle]);
   	maximize("100 ML, -5 familiar weight, -100 damage aura, equip fourth of may cosplay saber, -equip i voted, -equip Kramco Sausage-o-Matic", false);

	adv1(loc.to_location(), -1, "if hasskill 7310 && !haseffect 2464; skill 7310; endif; skill 7449; if hasskill feel hatred; skill feel hatred; endif; if hasskill snokebomb; skill snokebomb; endif; if hasskill reflex hammer; skill reflex hammer; endif; if hasskill 7301; skill 7301; endif");

	use_familiar(pre_pledge_fam);
  	cli_execute("outfit checkpoint; checkpoint clear");

	return have_effect($effect[Citizen of a Zone]).to_boolean() && visit_url(`desc_effect.php?whicheffect={$effect[Citizen of a Zone].descid}`).to_lower_case().contains_text(loc.to_lower_case());
}

//--camel
boolean camel_spit(){
	if(have_effect($effect[Spit Upon]).to_boolean()){
		return true;
	}

	if((have_familiar($familiar[Melodramedary])) && (get_property("camelSpit") == 100) && !have_effect($effect[Spit upon]).to_boolean()){

		print("Getting spit on!", "teal");
		use_familiar($familiar[Melodramedary]);

		adv1(scaler_zone, -1, `skill 7340; endif; if hasskill bowl a curveball; skill bowl a curveball; endif; {freerun}`);
	}

	return have_effect($effect[Spit Upon]).to_boolean();
}


//--melf
boolean melf_buff(){
	if(get_property("lcs_melf_slime_clan") == "" || !have_familiar($familiar[Machine Elf])){
		return false;
	}

	if(have_effect($effect[Inner Elf]).to_boolean()){
		return true;
	}

	print("Acquring your inner elf buff!", "teal");

	

	use_familiar($familiar[Machine Elf]);

	string prev_clan = get_clan_name();
	cli_execute(`try; /whitelist {get_property("lcs_melf_slime_clan")}`);

	if(!visit_url("clan_slimetube.php").contains_text("[boss exposed]")){
		abort("Uh-oh! Your slime clan isn't at mother slime!");
	} // TODO: Two people at slime tube at the same time?

	set_property("choiceAdventure326", "1");
	adv1($location[The Slime Tube], -1, "if hasskill bowl a curveball; skill bowl a curveball; endif; if hasskill snokebomb; skill snokebomb; endif; if hasskill KGB tranquilizer dart; skill KGB tranquilizer dart; endif; abort \"No banish to use!\"");

	cli_execute(`/whitelist {prev_clan}`);

	return have_effect($effect[Inner Elf]).to_boolean();
}


//--lovetunnel
void love_tunnel(){
	if(!visit_url("place.php?whichplace=town_wrong").to_lower_case().contains_text("tunnel of") || item_amount($item[LOV Extraterrestrial Chocolate]).to_boolean()){
       	return;
    }

    /* TODO Check item%? Remove ML?*/
	foreach it in $items[June Cleaver, Fourth Of May Cosplay Saber]{
		if(item_amount(it).to_boolean()){
			equip(it);
			break;
		}
	}

    string love_combat = "if monsterid 2009; attack; repeat; endif; if monsterid 2010; if hasskill toynado; skill toynado; repeat !times 3; endif; skill saucegeyser; repeat; endif; if monsterid 2011; attack; repeat; endif; abort;";
    
    
    int[int] loveNCs = { 1, 1, my_primestat() == $stat[Mysticality] ? 2 : my_primestat() == $stat[Muscle] ? 1 : 3 , 1, 2, 1, 3};

    foreach it in loveNCs {
        int temp = get_property(`choiceAdventure{1222 + it}`).to_int();
        set_property(`choiceAdventure{1222 + it}`, loveNCs[it].to_string());
        loveNCs[it] = temp;
    }

    while(!get_property("_loveTunnelUsed").to_boolean() || !item_amount($item[LOV Extraterrestrial Chocolate]).to_boolean()){ 
        adv1($location[the Tunnel of L.O.V.E.], -1, love_combat);
        
    }

    foreach it, x in loveNCs {
        set_property(`choiceAdventure{1467 + it}`, x.to_string());
    }

}

//--witchess
boolean witchess_fight(monster piece, string combat_filter){

	if(!get_campground()[$item[Witchess Set]].to_boolean() || get_property("_witchessFights").to_int() >= 5){
		return false;
	}

	visit_url("campground.php");
	visit_url("campground.php?action=witchess");
	run_choice(1);

	visit_url(`choice.php?option=1&pwd={my_hash()}&whichchoice=1182&piece={piece.to_int()}`, false, false);
	run_combat(combat_filter);

	return true;
}

//--cincho
int get_cincho_total(){
    int [int] cinchLevels = {30, 30, 30, 30, 30, 25, 20, 15, 10, 5};

	int total_cinch_level;	

    for(int i = get_property("timesRested").to_int(); i < total_free_rests(); i++) {
        total_cinch_level += (i >= count(cinchLevels)) ? 5 : cinchLevels[i];
    }

	return total_cinch_level;
}

//-barrelgod
void barrelgod(string type) { 
	if(get_property("barrelShrineUnlocked") == "false" || get_property("_barrelPrayer") == "true") {
		return;
	}
	cli_execute(`try; barrelprayer {type}`);// Amazing.
}


/// /// /// /// ///
string is_an(string it){
    return $strings[a, e, i, o, u] contains substring(it, 0, 1) ? "n" : "";
}

boolean pull_item(string ite){

	item it = ite.to_item();

	if(available_amount(it).to_boolean() || get_property("_roninStoragePulls").split_string(",") contains (it.to_int())){
		return true;
	}

	if(pulls_remaining() == 0){
		return false;
	}

  print(`Pulling a{is_an(it.to_string())} {it}!`, "teal");

	if(!storage_amount(it).to_boolean()){
		buy_using_storage(1, it);
	}

	take_storage(1,it);

	// weird case of yeg's motel toothbrush not working here? 
	if(it == $item[Yeg's Motel Toothbrush]){
		use(1, it);
	}

  return available_amount(it).to_boolean();
}

boolean pull_item(item it){
  if(available_amount(it).to_boolean()){
    return true;
  }

  if(pulls_remaining() == 0){
	return false;
  }

  print(`Pulling a{is_an(it.to_string())} {it}!`, "teal");

	if(!storage_amount(it).to_boolean()){
		buy_using_storage(1, it);
	}

	take_storage(1,it);

  return available_amount(it).to_boolean();
}

void equalize_stats(){
	switch(my_primestat()){
		case $stat[Mysticality]:
			get_effect($effect[Expert Oiliness]);
		break;

		case $stat[Moxie]: // TODO Fax this
			get_effect($effect[Slippery Oiliness]);
		break;

		case $stat[Muscle]:
			get_effect($effect[Stabilizing Oiliness]);
		break;
	}
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
	while(my_adventures() < (advs_to_gain + 1)){ // +1 for combo/any advs afterwards TODO
		// Sources of advs: Smith's tome food, Perfect Drinks, Astral Pilsners, Numberology, Borrowed Time, CBB food (t1/2s), Meteoreo, Meadeorite VIP Hot Dogs and Booze, Boxing Daycare
		if(!have_effect($effect[Ode to Booze]).to_boolean()){
			use_skill($skill[The Ode to Booze]);
		}
		
		if(item_amount($item[Astral Pilsner]).to_boolean()){
			drink(1, $item[Astral Pilsner]);
			// drink(min(ceil(advs_to_gain / 11.0).to_int(), item_amount($item[Astral Pilsner])), $item[Astral Pilsner]);
		}



	}

	return my_adventures() > advs_to_gain;
}

// TODO synthesis oh no
boolean synthesis_effect(effect eff){
	if(have_effect(eff).to_boolean()){
		return true;
	}

	if(!have_skill($skill[Sweet Synthesis])){
		return false;
	}

	return false;
}

boolean use_current_best_fam(){
	// CS Optimal familiars: CBB (6.6 turns on item%) -> Camel (4 turns on weapon damage, 2 on spell damage) -> Shortest-Order Cook (2 turns on familiar weight) -> Garbage Fire (1-2 turns on familiar weight) -> Sombrero (Stats)
	if((my_primestat() == $stat[Mysticality] || my_class() == $class[Accordion Thief]) && have_familiar($familiar[Cookbookbat]) && get_property("lcs_get_cbb_vegetable") != "No" && item_amount($item[Vegetable of Jarlsberg]) < 2){
		use_familiar($familiar[Cookbookbat]);
		return true;
	}

	if((have_familiar($familiar[Melodramedary]) && get_property("camelSpit").to_int() < 100) && !have_effect($effect[Spit Upon]).to_boolean()){
		use_familiar($familiar[Melodramedary]);
		if(item_amount($item[dromedary drinking helmet]).to_boolean()){
			equip($item[dromedary drinking helmet]);
		}
		return true;
	}

	if(have_familiar($familiar[Garbage Fire]) && (!available_amount($item[burning paper crane]).to_boolean() || item_amount($item[burning newspaper]).to_boolean())){
		use_familiar($familiar[Garbage Fire]);
		return true;
	}

	if(have_familiar($familiar[Shorter-Order Cook]) && !item_amount($item[short stack of pancakes]).to_boolean() && !have_effect($effect[Shortly Stacked]).to_boolean()){
		use_familiar($familiar[Shorter-Order Cook]);
		return true;
	}

	if(have_familiar($familiar[Artistic Goth Kid])){ // Free occasional wanderers, which probably won't screw up the script
		use_familiar($familiar[Artistic Goth Kid]);
		return true;
	}

	if(have_familiar($familiar[Jill-of-All-Trades])){
		use_familiar($familiar[Jill-of-All-Trades]);
		return true;
	}

	if(have_familiar($familiar[Hovering Sombrero])){
		use_familiar($familiar[Hovering Sombrero]);
		return true;
	}
	
	return false;


}

record reffect {
	int price;
	string item_name;
	effect eff;
	modifier mod;
	boolean function;
	boolean tried;

	/* Use numeric_modifier((test_eyelashes.eff, test_eyelashes.mod) for potency */
};


// reffect test_eyelashes = new rEffect(100, "Glittery Mascara", $effect[Glittering Eyelashes], $modifier[Mysticality Percent], false, false);




effect eff;

string [int] powerlevel_effects = {
    "Ode to Booze",
    "Big",
    "Carol of the Thrills",
    "Ur-Kel's Aria of Annoyance",
    "Shanty of Superiority",
    "Leash of Linguini",
	"Confidence of the Votive",
    "Empathy",
    "Pride of the Puffin",
    "Feeling Nervous",
    "Feeling Excited",
    "Feeling Peaceful",
    "Blood Bubble",
    "Song of Bravado",
    "Blood Bond",
    "Bendin' Hell",
    "Triple-Sized",
	"Total Protonic Reversal",
	"Drescher's annoying noise",
	"Astral Shell",
};


string [int] powerlevel_mys_effects = {
    "Glittering Eyelashes",
    "Inscrutable Gaze",
    "Saucemastery",
    "Spirit of Cayenne",
    "Disdain of she-who-was",
	"Mystically Oiled",
};

string [int] powerlevel_mus_effects = {
	"Seal Clubbing Frenzy",
	"Patience of the Tortoise",
	"Disdain of the War Snapper",
	"Go Get 'Em, Tiger!",
	"Rage of the Reindeer",
	"Carol of the Bulls",
	"Phorcefullness",
};

string [int] powerlevel_mox_effects = {
	// ¯\_(ツ)_/¯
};

/* Effects go here, numbered by priority */

string[int] mys_effects = {
    0: "Glittering Eyelashes",
    1: "Quiet Judgement",
    2: "Stevedave's Shanty of Superiority",
};

string[int] mox_effects = {
    0: "Song of bravado",
    1: "Blubbered up",
    2: "Disco state of mind",
    3: "Mariachi mood",
    4: "Butt-rock hair",
    5: "Unrunnable face",
    6: "Feeling Excited",
    7: "Quiet Desperation",
    8: "Stevedave's Shanty of Superiority",
    9: "The Moxious Madrigal",
    10: "aMAZing",
    
};

string[int] mus_effects = {
    0: "Go get 'em, tiger!",
    1: "Seal clubbing frenzy",
    2: "Rage of the reindeer",
    3: "Patience of the tortoise",
    4: "Disdain of the war snapper",
    5: "Song of bravado",
    6: "Quiet determination",
    7: "Feeling excited",
    8: "Phorcefullness",
	9: "Lack of Body-Building",	
    10: "The Power of LOV",
	11: "In the Depths",
};

string[int] hp_effects = {
    0: "Song of starch", // 0
    1: "Reptilian fortitude", // 0
    2: "Plump and Chubby",
};


string[int] item_effects = {
    0: "FUNC eagle_pledge / Madness Bakery", // In case of failure
    1: "Empathy",
    2: "Steely-Eyed Squint", // 0
    3: "Fat Leon's Phat Loot Lyric", // 0
    4: "Singer's Faithful Ocelot", // 0
    40: "Spice haze", // 0
    369: "Crunching Leaves", // 369
    1375: "Nearly All-Natural", // 1375
    1000: "Heart of Lavender",
    1890: "FUNC catalog / boots", // 1890
    2000: "Ermine Eyes", // 2000
    3150: "FUNC catalog / rhymes", // 3150
    3200: "Fortune of the Wheel", // 3200
    3000: "Wizard Sight", // 333 + 2 * VoA
    3750: "FUNC wish_effect / Infernal Thirst", // 3750
    8958: "El Aroma de Salsa", // 8958
    8980: "Glowing Hands", // 8980
    15000: "Incredibly Well Lit", // 15000
    18000: "Feeling Lost", // Potentially 2-4 * voa
    13750: "Lantern-Charged", // 13750
};


string[int] hot_res_effects = {
    0: "Elemental Saucesphere", // 0
    1: "Astral Shell", // 0
    2: "Leash of Linguini", // 0
    3: "Empathy", // 0
    4: "Amazing",
    5: "Feeling Peaceful", // 0
    6: "Hot-headed",
    7: "Rainbow Vaccine", // 0
};


string[int] fam_weight_effects = {
    0: "Empathy", // 0
    1: "Leash of Linguini", // 0
    2: "Blood Bond", // 0
	660: "Do I Know You From Somewhere?", //
    1525: "Robot Friends", // 1525
    2200: "Heart of Green", 
    1726: "Billiards Belligerence", // 1726
	2500: "Man's Worst Enemy",
	3250: "Shrimpin' Ain't Easy",
    3889: "Shortly Stacked", // 3889
    5193: "Loyal as a Rock", // 5193
    6390: "Party Soundtrack", // 6390
    17000: "Puzzle Champ", // 17000
};

string[int] non_combat_effects = {
    0: "Smooth Movements", // 0
    1: "The Sonata of Sneakiness", // 0
    2: "Leash of Linguini", // 0
    3: "Blood Bond",
    4: "Empathy", // 0
    5: "Feeling Lonely", // 0
    6: "Silent Running", // 0
    83: "Feeling Sneaky", // 83
    1377: "A Rose by any Other Material", // 1377
    1500: "Throwing Some Shade", // 1500
    149: "Shortly Buttered",
    6969: "Invisible Avatar", // Marginal embezzler turn - 6 * VoA
    8630: "Billiards Belligerence", // 8630
    25965: "Loyal as a Rock", // 25965
    4166: "FUNC wish_effect / Disquiet Riot", // 4166
};

string[int] weapon_damage_effects = {
    0: "Bow-Legged Swagger", // 0
    1: "Scowl of the auk", // 0
    2: "Tenacity of the snapper", // 0
    3: "Frenzied, bloody", // 0
    4: "Disdain of the war snapper", // 0
    5: "Jackasses' Symphony of Destruction", // 0
    6: "Lack of body-building", // 0
    7: "Carol of the Bulls", // 0
	8: "Song of the North", // 0
    9: "Rage of the Reindeer", // 0
    35: "Cowrruption", // 35
    100: "Feeling punchy", // 100
    150: "Imported Strength", // 150
    750: "Engorged weapon", // 750
    758: "Pronounced Potency", // 758
    1136: "Ham-fisted", // 1136
    1136: "Wasabi With You", // 1136
    1750: "Faboooo", // 1750
    1726: "Billiards Belligerence", // 1726
    2500: "The Power of LOV", // 2500
    2437: "FUNC pull_item / Yeg's Motel toothbrush", // 2437
    6250: "FUNC wish_effect / Outer Wolf", // 6250
};

string[int] spell_damage_effects = {
    0: "Jackasses' Symphony of Destruction", // 0
    1: "Arched Eyebrow of the Archmage", // 0
    2: "Carol of the Hells", // 0
    3: "Spirit of Peppermint", // 0
    4: "Song of Sauce", // 0
	5: "In the 'zone zone!", // 0
    69: "Cowrruption", // 69. nice.
    500: "Paging Betty", // @9k in the mall, but I don't think these sell. TODO use coldfront mall data?
    300: "Imported Strength", // 300
    700: "We're all made of starfish", // ~700
    850: "Concentration", // 850
    1726: "Mental A-cue-ity", // 1726
    2620: "The Magic of LOV", // 2620
    9000: "AAA-Charged", // 9000
    18000: "AA-Charged", // 18000
    27000: "D-Charged", // 27000
};


int buff_up(int test){

string [int] effects;
// TODO Sort this by value/turn save
// Makes a copy of the map to effects
	switch(test){
	
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

	// effects[eff] == value. If it's 0, it's unlimited and/or free! -1 means used. Otherwise, it's cost in meat per turn saved.
	// TODO: Re-entry via preference?
	int i;

	foreach value, eff in effects{
		
		if(eff != -1){
			effects[value] = -1;

			if(eff.substring(0,4) == "FUNC"){
				string[int] func_effect = split_string(eff, " \\/ ");
				// func_effect[0] => function name, func_effect[1] => input to pass through, 
				
				string function = func_effect[0].substring(5);
				call boolean function(func_effect[1]);
				
				print(`~{test_turns(test)} turns left to save!`, "lime");
				break;
			} 

			effect effe = eff.to_effect();

			if(!have_effect(effe).to_boolean()){

				if(get_effect(effe)){
					print(`Successfully obtained effect {effe}, ~{test_turns(test)} turns left to save!`, "lime");
					break;
				} 

			} 
		} else {
			i++;

			if(effects.count() == i){
				print(`We couldn't reach your turn treshold with all your resources. ({scrape_test_turns(test)} turns left)`, "red");
				// TODO lol
				if(get_property("lcs_seventy") == "true"){
					print("But we're attempting a 1/70 run. Time to burn wishes now!", "teal");
					print(`Sorry, not implemented yet >.<`);
				}

				abort();

			}
		}

	}
		
	return scrape_test_turns(test);
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

string [int] weapon_modifiers = {
	0: "Weapon Damage Percent",
	1: "Weapon Damage",
};

 
string [int] item_modifiers = {
	0: "Item Drop",
	1: "Booze Drop"
};



void cs_test(int testnum){

	while(scrape_test_turns(testnum) > get_property(`lcs_turn_threshold_{test_number_to_name(testnum)}`).to_int()){
  		buff_up(testnum);
	} 

	switch(testnum){
		case 1:
			get_modtrace("Maximum HP Percent");
		break;

		case 2:
			get_modtrace("Muscle percent");
		break;

		case 3:
			get_modtrace("Mysticality percent");
		break;

		case 4:
			get_modtrace("Moxie percent");
		break;

		case 5:
			get_modtrace("Familiar Weight");
		break;

		case 6:
			get_modtrace(weapon_modifiers);
		break;

		case 7:
			get_modtrace(spell_modifiers);
		break;

		case 9:
			get_modtrace(item_modifiers);
		break;

		case 10:
			get_modtrace("Hot resistance");
		break;


	}

	matcher remove_underscores = create_matcher(" ", test_number_to_name(testnum));
    string test_name = replace_first(remove_underscores, "_");

	print(`Expected turns for test {test_name}: {test_turns(testnum)} turns`, "lime");
	
	print(`(Looking at the council.php text gives us a turn amount of {scrape_test_turns(testnum)})`, "teal");
	if(scrape_test_turns(testnum) != test_turns(testnum) && test_turns(testnum) != 1 && scrape_test_turns(testnum) != 1){
		print("Uh-oh. The estimated script turn amount and council turn amount are different! We'll continue and use the latter", "red");
		waitq(2);
	}

	visit_url("council.php");	
	if(scrape_test_turns(testnum) <= get_property(`lcs_turn_threshold_{test_number_to_name(testnum)}`).to_int()){
		gain_adventures(scrape_test_turns(testnum));
		visit_url(`choice.php?whichchoice=1089&option={testnum}&pwd`);
	} else {
		abort("Manually do the test, see if you can optimize any further, then ping me with any effects which to be added if needed) ^w^");
	}
}
