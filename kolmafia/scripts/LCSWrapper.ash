script "lcswrapper.ash";
import <LCSWrapperResources.ash>
import <LCSWrapperMenu.ash>

// LCSWrapper - The entire run, drawn upon resources in the LCSWrapperResources script. The preference manager/summary are located in LCSWrapperMenu. Combat is mostly in this script, but is slowly being shifted to LCSWrapperCombat.

print_html("<center><font color=66b2b2><font size=3><i>Running LCSWrapper!</i></font></font></center>");

int turns;
boolean test;
boolean sekrit;
string lcs_abort = "abort";
// Freerun macro to call back on in other macros
string freerun = "if hasskill feel hatred; skill feel hatred; endif; if hasskill snokebomb; skill snokebomb; endif; if hasskill reflex hammer; skill reflex hammer; endif; if hasskill 7301; skill 7301; endif";

// Ascends sauceror, path blender. Buys astral pilsners & a pet sweater 
void ascend() {
  visit_url("afterlife.php?action=pearlygates");
  visit_url( "afterlife.php?action=buydeli&whichitem=5040" );

  print("Stepping into the Mortal Realm in 25 seconds without any perms! Press ESC to manually perm skills!", "teal");
  waitq(20); 
  wait(5);

  visit_url("afterlife.php?action=ascend&confirmascend=1&whichsign=8&gender=2&whichclass=4&whichpath=25&asctype=2&nopetok=1&noskillsok=1&pwd", true);
  visit_url("choice.php");
  run_choice(1);
  refresh(); 
}

// Toot oriole/Start-of-day-actions
void oriole() {

if(get_property("_birdOfTheDayMods") == ""){
  print("Visiting your favourite bird...", "teal");
} else {
  print("Visiting your second favourite bird...", "teal");
}

if(get_property("questM05Toot") != "finished"){
  visit_url('tutorial.php?action=toot');
  use(1, $item[letter from king ralph xi]);
  use(1, $item[pork elf goodies sack]);

  // Mayday owners / trainset owners save a baconstone and hamethyst for desert potions later on
  if((get_property("hasMaydayContract").to_boolean() && my_class() == $class[Sauceror]) || get_property("trainsetConfiguration") != ""){
    autosell(5, $item[Porquoise]);

    foreach it in $items[Baconstone, Hamethyst]{
    int temp = item_amount(it);
      if(temp > 1){
        autosell(temp - 1, it);
      }
    }

  } else {
    foreach it in $items[Baconstone, Hamethyst, Porquoise]{
      autosell(5,it);
    }
  }

}

print("Now setting up beginning-of-ascension stuff...", "teal");

if(get_property("lcs_autopull_at_start") != "" && pulls_remaining() == 5){

  print("Now pulling some items automatically for you!", "teal");
  newline();
  foreach x, it in split_string(get_property("lcs_autopull_at_start"), "\\,"){
    if(it.to_item() == $item[none]){
      print(`Warning: {it} is not a valid item to be pulled!`, "red");
      waitq(5);
    } else {
      string ite = it.to_item().to_string();
      print(`Pulling 1 {ite}!`, "teal");
      cli_execute(`hagnk {ite}`);
    }
  }

}


if(!available_amount($item[Toy accordion]).to_boolean()){
  retrieve_item(1, $item[Toy accordion]);
}

if(available_amount($item[Songboom&trade; Boombox]) > 0 && get_property("boomBoxSong") != "Total Eclipse of Your Meat"){
	cli_execute("Boombox meat");
}

if ((get_property("_saberMod").to_int() == 0) || (available_amount($item[Fourth of May Cosplay Saber]).to_boolean())) {
	visit_url("main.php?action=may4");
	run_choice(4);
}

if((available_amount($item[S.I.T. Course Completion Certificate]).to_boolean()) && !get_property("_sitCourseCompleted").to_boolean()){
  string prev_SIT = get_property("choiceAdventure1494");
  set_property("choiceAdventure1494", "1");
  use(1, $item[S.I.T. Course Completion Certificate]);
  set_property("choiceAdventure1494", prev_SIT);
}

maximize("0.2 mp, 0.2 hp, 0.1 item, 3 familiar weight, 5 mysticality exp, 10 mysticality experience percent, mys percent, 0.1 mys, 0.001 DA, 69 bonus tiny stillsuit, 80 bonus dromedary drinking helmet, 3000 bonus designer sweatpants, 1000 bonus latte lovers member's mug, 200 bonus jurassic parka, 200 bonus june cleaver, -equip broken champagne bottle, -equip Kramco Sausage-o-Matic -equip makeshift garbage shirt -equip i voted -tie", false);

if(item_amount($item[autumn-aton]).to_boolean()){
  cli_execute("Autumnaton send sleazy back alley");
}

boolean tmp;
foreach fam in $familiars[Cookbookbat, Melodramedary, Shorter-Order Cook, Disgeist, Hovering Sombrero]{
  if(have_familiar(fam) && !tmp){
    use_familiar(fam);
    tmp = true;
  }
}

if(get_property("chateauAvailable").to_boolean() && !get_property("_chateauDeskHarvested").to_boolean()){
  visit_url("place.php?whichplace=chateau&action=chateau_desk");
}

if(!available_amount($item[your cowboy boots]).to_boolean() && get_property("telegraphOfficeAvailable").to_boolean()){
  visit_url("place.php?whichplace=town_right&action=townright_ltt");
}

if(get_property("hasDetectiveSchool").to_boolean() && !(available_amount($item[plastic detective badge]).to_boolean() && available_amount($item[bronze detective badge]).to_boolean() && available_amount($item[silver detective badge]).to_boolean() && available_amount($item[gold detective badge]).to_boolean())){
  visit_url("place.php?whichplace=town_wrong&action=townwrong_precinct");
}

if(!have_skill($skill[Seek out a Bird]) && item_amount($item[Bird-a-Day calendar]).to_boolean()){
  use(1, $item[Bird-a-Day calendar]);
}

if(familiar_equipped_equipment(my_familiar()) != $item[Tiny Stillsuit] && familiar_equipped_equipment(my_familiar()) != $item[dromedary drinking helmet] &&available_amount($item[Tiny Stillsuit]).to_boolean()){
  equip($slot[Familiar], $item[Tiny Stillsuit]);
}

if(item_amount($item[mumming trunk]) > 0) {
	cli_execute('try; mummery mys');
}

if(get_property("frAlways").to_boolean() && available_amount($item[Fantasyrealm g. e. m.]) == 0) {
	visit_url('place.php?whichplace=realm_fantasy&action=fr_initcenter');
  run_choice(2);
  refresh();
}

if(item_amount($item[Model Train Set]).to_boolean()){
  print("Using your train set", "teal");

  use(1, $item[Model Train Set]);
  if(visit_url("campground.php?action=workshed",false,true).contains_text('value="Save Train Set Configuration"')){
    // all stat -> coal -> mys -> meat -> mp -> ore -> ml -> hotres
    // [  WE ONLY HIT THESE  ]   [       THESE DO NOT MATTER      ]

    visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=3&slot[1]=8&slot[2]=16&slot[3]=1&slot[4]=2&slot[5]=20&slot[6]=19&slot[7]=4",true,true);
    refresh();
  }
}

if(!available_amount($item[Ebony Epee]).to_boolean() && item_amount($item[Spinmaster&trade; lathe]).to_boolean()) {
	visit_url("shop.php?whichshop=lathe");
	retrieve_item(1, $item[Ebony Epee]);
}

set_auto_attack(0);

cli_execute("backupcamera reverser on");
if(!visit_url("campground.php").contains_text("mushroom")){
  cli_execute("garden pick");
}


if(item_amount($item[Whet Stone]).to_boolean()){
  use(1, $item[Whet Stone]);
}

if(available_amount($item[astral six-pack]).to_boolean()){
  use(1, $item[astral six-pack]);
  use(1, $item[Newbiesport&trade; tent]);
}

}



void coil_wire(){

if(item_amount($item[Ear Candle]).to_boolean()){
  get_effect($effect[Clear Ears, Can't Lose]);
  get_effect($effect[The Odour of Magick]);
}

if (have_effect($effect[Inscrutable Gaze]) == 0){
  use_skill(1, to_skill($effect[Inscrutable Gaze]));
}

if ((get_property("voteAlways").to_boolean()) && !(get_property("_voteToday").to_boolean())){
  visit_url('place.php?whichplace=town_right&action=townright_vote');
  waitq(1);
  if(my_class() == $class[Sauceror]){
    visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=1&local[]=1',true,false);
  } else {
    visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=2&local[]=2',true,false);
  }
  set_property("_voteToday", "true");

  print(`Your local initiative gives you {get_property("_voteModifier")}.`, "teal");
} 

if(get_property('questM23Meatsmith') == 'unstarted') {
	visit_url('shop.php?whichshop=meatsmith&action=talk');
	run_choice(1);
}

if(get_property('questM25Armorer') == 'unstarted') {
	visit_url('shop.php?whichshop=armory&action=talk');
	run_choice(1);

  adv1($location[Madness Bakery], -1, "abort");
}

if(item_amount($item[2002 Mr. Store Catalog]).to_boolean() && !get_property("_2002MrStoreCreditsCollected").to_boolean()){
  use(1, $item[2002 Mr. Store Catalog]);
  refresh();
}

if(get_property("_clanFortuneConsultUses").to_int() != 3){
  string chatbot;

  switch (get_clan_name()){

    case "The Average Clan":
      chatbot = "averagechat";
    break;

    case "Bonus Adventures From Hell":
      chatbot = "cheesefax";
    break;

    case "Cool Guy Crew":
      chatbot = "coolestrobot";
    break;
  }

  if(chatbot != ""){
    for i from 1 to 3 - get_property("_clanFortuneConsultUses").to_int(){
      visit_url("clan_viplounge.php?preaction=lovetester");
      visit_url(`choice.php?pwd&whichchoice=1278&option=1&which=1&whichid={chatbot}&q1=pizza&q2=thisIsNotCompatible&q3=thick`);
      wait(8);
    }
  }
}




if(available_amount($item[Cherry]) == 0){
print("Adventuring/mapping for a novelty tropical skeleton!", "teal");
cli_execute("parka dilophosaur");

set_auto_attack("none");

string cs_wrapper_freerun = `if monstername novelty tropical skeleton || monsterid 1746; skill spit jurassic acid; abort; endif; {freerun};`;

if((have_familiar($familiar[Pair of Stomping Boots])) && (!have_skill($skill[Map the Monsters]))){
  cs_wrapper_freerun = "if monstername novelty tropical skeleton || monsterid 1746; skill spit jurassic acid; abort; endif; runaway";
  use_familiar($familiar[Pair of Stomping Boots]);
  if(!have_familiar($familiar[Shorter-Order Cook])){
    use_skill($skill[Leash of Linguini]);
    cli_execute("Up empathy");
  }
}

if (have_skill($skill[Map the Monsters])){

  if(!contains_text(get_property("lastEncounter"), "Skeletons In Store")){
    adv1($location[The Skeleton Store], -1, "abort");
  }

  use_skill($skill[Map the Monsters]);

  visit_url("adventure.php?snarfblat=439");
  if (handling_choice() && last_choice() == 1435){
    run_choice(1, false, `heyscriptswhatsupwinkwink={$monster[Novelty Tropical Skeleton].to_int()}`);

    run_combat("skill spit jurassic acid; abort");
  } else { abort("We couldn't map properly...?"); }
} else {
  while(item_amount($item[Cherry]) == 0){

    if((my_mp() < 30) &&(!have_skill($skill[Feel Hatred]).to_boolean())){
        buy(2, $item[Doc Galaktik's Invigorating Tonic]);
        use(2, $item[Doc Galaktik's Invigorating Tonic]);
    }

    adv1($location[The Skeleton Store], -1, cs_wrapper_freerun);
    if(((get_property("_banderRunaways").to_int() + 1) * 5) >= numeric_modifier("Familiar Weight")){
      abort("Either we're somewhat unlucky or something went really wrong");
    } // TODO: Orb? We have no orbfishing reset tho =(
  }
}

print("Stat equalizer obtained!", "teal");
newline();
if(!item_amount($item[Cherry]).to_boolean()){
  abort("We don't have a cherry? Uh oh.");
}

}

if((get_property("_juneCleaverFightsLeft") == 0) && have_equipped($item[June Cleaver])){
  adv1($location[Noob Cave]);
  // TODO: June cleaver choice advs
}

if((have_familiar($familiar[Pair of Stomping Boots]) || (test) || have_familiar($familiar[Frumious Bandersnatch])) && !in_hardcore()){
    string shadow_freerun = "if hasskill feel hatred; skill feel hatred; endif; if hasskill reflex hammer; skill reflex hammer; endif; if hasskill snokebomb; skill snokebomb; endif; if hasskill Throw Latte on Opponent; skill Throw Latte on Opponent; endif; abort;";
    
    if(have_familiar($familiar[Pair of Stomping Boots])){
      get_effect($effect[Empathy]);
      use_familiar($familiar[Pair of Stomping Boots]);
      shadow_freerun = "runaway; abort";
    } else if (have_familiar($familiar[Frumious Bandersnatch])){
      get_effect($effect[Empathy]);
      get_effect($effect[Ode to Booze]);
      use_familiar($familiar[Frumious Bandersnatch]);
      shadow_freerun = "runaway; abort";
    }
    
    
    if(get_property("trainsetPosition").to_int() > 3 && my_level() < 3){
      abort("Trainset went over myst, yet we're lower then level 3...");
    }

    while(get_property("trainsetPosition").to_int() < 3){
      adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, shadow_freerun);
    }


    if(40 + get_property("lastTrainsetConfiguration").to_int() - get_property("trainsetPosition").to_int() >= 0){
      print("Resetting train position to hit coal -> myst again!", "teal");
      visit_url("campground.php?action=workshed");
      visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=14&slot[1]=4&slot[2]=7&slot[3]=8&slot[4]=16&slot[5]=1&slot[6]=3&slot[7]=17",true,true);
    }

    while(get_property("trainsetPosition").to_int() < 5){
      adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, shadow_freerun);
      
      if((get_property("_banderRunaways").to_int() * 5) > numeric_modifier("Familiar Weight")){
        abort("Uh-oh. Something went really wrong.");
      }
    }

    if(my_level() < 5){
      abort("Didn't reach the target goal of level 5!");
    }

    if(storage_amount($item[Calzone of Legend]).to_boolean()){
      take_storage(1,$item[calzone of legend]);
    } else {
      print("We don't have a calzone of legend...", "red");
    }
} else if((my_level() < 5 || !item_amount($item[Calzone of Legend]).to_boolean()) && !in_hardcore()){

if(!get_property("_borrowedTimeUsed").to_boolean() && !clip_art($item[Borrowed Time])){
  pull_item($item[Borrowed Time]);
}

if(item_amount($item[Borrowed Time]).to_boolean()){
  use(1, $item[Borrowed Time]);
}

}

if(in_hardcore()){ // TODO: Smith's tome can potentially have better food and/or booze

  if(clip_art($item[Borrowed Time])){
    print("Borrowed time successfully made!", "teal");
    use(1, $item[Borrowed Time]);
  } else {
    print("We're in hardcore without clip art, so we'll be getting some distilled wine!", "teal");
    retrieve_item($item[11-Leaf Clover]);
    use(1, $item[11-Leaf Clover]);

    adv1($location[The Sleazy Back Alley], -1, lcs_abort);

    get_effect($effect[Ode to Booze]);
    drink(3, $item[Distilled fortified wine]);
  }
}

print("Adventuring in the NEP! (Setting up bowling ball + spikes)", "teal");

cli_execute("parka spikolodon");

if(item_amount($item[Industrial Fire extinguisher]).to_boolean()){
  equip($item[Industrial Fire extinguisher]);
}


if((available_amount($item[red rocket]) == 0) && (have_effect($effect[Everything Looks Red]) == 0)){
  buy(1, $item[Red Rocket]);
}

if((available_amount($item[Kramco Sausage-o-Matic&trade;]).to_boolean()) && (!get_property("_spikolodonSpikeUses").to_boolean())){

  if(get_property("_questPartyFair") == "unstarted"){
    visit_url("adventure.php?snarfblat=528");

    switch (get_property("_questPartyFairQuest")) {
      case "food": 
        run_choice(1);
      break;

      case "booze":
        run_choice(1);
      break;

      default:
        run_choice(2);
      break;
    }
  }

  equip($item[Kramco Sausage-o-Matic&trade;]);

  if(available_amount($item[Industrial Fire Extinguisher]).to_boolean()){
  equip($item[Industrial Fire Extinguisher]); }

  use_current_best_fam();

  // TODO: Melodram hump

  if(my_hp() < my_maxhp()){
    cli_execute("hottub");
  }

  string cswrappersideways = "if hasskill	Fire Extinguisher: Foam 'em Up; skill Fire Extinguisher: Foam 'em Up; endif; if hasskill bowl sideways; skill bowl sideways; endif; if hascombatitem red rocket; use red rocket; endif; if hasskill Launch spikolodon spikes; skill Launch spikolodon spikes; endif; attack;";
  adv1($location[The Neverending Party], -1, cswrappersideways);
}

if((item_amount($item[Calzone of Legend]).to_boolean()) && (my_level() >= 5)){
  eat(1, $item[Calzone of Legend]);
}

if(available_amount($item[Magical sausage casing]) == 0){
  abort("Uh oh! We didn't get a magical sausage? Check what went wrong. (You may just not have a kramco. In that case, ow. Manually do coil wire and rerun.)");
}

maximize("MP, 0.1 mys percent, 10 MP Regen", false);

// TODO: Blue Rocket for the above ^

visit_url("council.php");
refresh();
visit_url("council.php");
visit_url("choice.php?whichchoice=1089&option=11&pwd");

if(!contains_text(get_property("csServicesPerformed"), "Coil Wire")){
  abort("You don't have 60 adventures to coil some wire");
}

}


void powerlevel(){

if(contains_text(get_property("csServicesPerformed"), "Build Playground Mazes")){ 
  if(!user_confirm(`Are you sure you want to continue powerleveling, even after doing the mys test?`)){
    abort("Run 'lcswrapper skipleveling' to skip powerleveling!");
  }
}



print("Powerleveling!", "teal");

if(have_equipped($item[Kramco Sausage-o-Matic&trade;])){
  cli_execute("unequip offhand");
}

if(item_amount($item[MayDay&trade; supply package]).to_boolean()){
  use(1, $item[MayDay&trade; supply package]);
  autosell(1,$item[Space Blanket]);
}

if(pulls_remaining() < 1 && !in_hardcore()){
 print("We have no pulls? Uh-oh.", "red");
 waitq(5);
}

if ((have_effect($effect[Tomes of Opportunity]) == 0) && get_property("noncombatForcerActive").to_boolean() && (my_adventures() > 0)){

  if(holiday() != ""){

    switch(holiday().split_string(" \\/ ")[0]){
      default:
        print(`It's {holiday()}! This may affect the script in unforseen ways.`, "teal");
      break;

      case "Crimbo":
        print("Happy Crimbo!", "teal");
      break;

      case "Festival of Jarlsberg":
        print("Happy Festival of Jarlsberg! This script will be ever so slightly more profitable today~", "teal");
      break;

      case "Halloween":
        print("Happy Halloween! This script won't Trick-or-Treat for you, unfortunately. Maybe next time, hehe.");

      case "Dependence Day":
        print("Happy Dependence Day! Let's buy a sparkler to celebrate!", "teal");
        buy(1, $item[Sparkler]);
        use(1, $item[Sparkler]);
      break;

      case "Generic Summer Holiday":
        print("It's a generic summer holiday! Don't forget to take a dip in the fountain after this script finishes!", "teal");
      break;

      case "Yuletide":
        print("Happy Yuletide! Don't forget to have some marshmallows around a campfire later!", "teal");
      break;

      case "Talk Like a Pirate Day":
        print("It be talk like a pirate day, matey! Let's make the wanderer walk the plank, mhmm?", "teal");
        visit_url("adventure.php?snarfblat=528");
        run_combat(freerun);
      break;

      case "El Dia de Los Muertos Borrachos":
      case "Feast of Boris":
        print(`It's {holiday()}! Let's get rid of the starting wanderer now, and hope another one doesn't come~`, "teal");
        
        visit_url("adventure.php?snarfblat=528");
        run_combat(freerun);
      break;
    }
  }

  visit_url("adventure.php?snarfblat=528"); // Stops on holiday wanderers. TODO
  if(current_round() == 1){
    run_combat(freerun);
  }
  run_choice(1); run_choice(2);
}

/*

if((sekrit) && (!have_effect($effect[All Wound Up]).to_boolean())){
  print("Pulling an wind-up meatcar...", "teal");
  if(!storage_amount($item[Wind-up meatcar]).to_boolean()){
    buy_using_storage(1, $item[Wind-up meatcar]);
  }

  take_storage(1,$item[Wind-up meatcar]);
  use(1, $item[Wind-up meatcar]);

} else if(have_effect($effect[Category]) == 0){
  print("Pulling an abstraction: category...", "teal");
  
  if(!storage_amount($item[Abstraction: category]).to_boolean()){
    buy_using_storage(1, $item[Abstraction: category]);
  }

  take_storage(1,$item[Abstraction: category]);
  use(1, $item[Abstraction: category]);
}
*/
if(get_property("lcs_august_scepter") == "Offhand Remarkable Before Powerleveling"){
  august_scepter(13);
}

if(!available_amount($item[Cincho de Mayo]).to_boolean() && !in_hardcore()){

  if((have_effect($effect[Different Way of Seeing Things]) == 0) && (pulls_remaining() > 0) && !wish_effect("Different Way of Seeing Things")){

    // Saves us a pull, which is more useful later!

    if(mall_price($item[Non-Euclidean angle]) > (50000 + 1.88 * get_property("valueOfAdventure").to_float())){
      print("Pulling a wish, as the angle is worth more ...", "teal");

      pull_item($item[Pocket Wish]);
      cli_execute("genie effect Different Way of Seeing Things");
          
    } else { 
      pull_item($item[non-Euclidean angle]);
      use(1, $item[non-Euclidean angle]);
    }
  }
}

if(get_property("tomeSummons") == "0" && !have_effect($effect[Purity of Spirit]).to_boolean()){
  if(clip_art($item[cold-filtered water])){
    use(1, $item[cold-filtered water]);
  }
}

visit_url("desc_item.php?whichitem=661049168");
refresh();

// TODO: Most of these properties have been moved over to wish_effect, so this area needs some cleaning
if(get_property("lcs_get_warbear_potion") == "Yes"){
  if((get_property("_g9Effect").to_int() >= 200) && (have_effect($effect[Experimental Effect G-9]) == 0) && (pulls_remaining() > 0)){
    print("Getting experimental effect G-9...", "teal");

    if(!wish_effect("Experimental Effect G-9")){
      pull_item($item[experimental serum G-9]);
      use(1, $item[experimental serum G-9]);
    }

  } else if((have_effect($effect[New and Improved]) == 0) && (get_property("_g9Effect").to_int() <= 200) && (pulls_remaining() > 0) && !wish_effect("New and Improved")){

    pull_item($item[warbear rejuvenation potion]);
    use(1, $item[warbear rejuvenation potion]);
  } 
}

if(my_id() == 3272033){
  wish_effect("Witch Breaded");
}


if(in_hardcore()){
  if(get_property("_g9Effect").to_int() >= 200){
    wish_effect("Experimental Effect G-9");
  } else { 
    wish_effect("New and Improved");
  }

  foreach eff in $strings[A Contender, Different Way of Seeing Things]{
    wish_effect(eff);
  }
}


if(available_amount($item[Eight Days a Week Pill Keeper]).to_boolean() && have_familiar($familiar[Comma Chameleon]) && !have_effect($effect[Hulkien]).to_boolean()){
  cli_execute("pillkeeper stat");
}


if(!have_effect($effect[A Contender]).to_boolean() && get_property("lcs_get_a_contender") == "Yes"){
  wish_effect("A contender");
}

if(!get_property('_clanFortuneBuffUsed').to_boolean() && get_property("lcs_vip_fortune_buff") != "None"){
  cli_execute(`fortune buff {get_property("lcs_vip_fortune_buff").to_lower_case()}`);
}

if(available_amount($item[pebble of proud pyrite]).to_boolean()){
  use(1, $item[pebble of proud pyrite]);
}

if (!get_property('_floundryItemCreated').to_boolean() && get_property("lcs_foundry") != "None"){
  cli_execute(`acquire {get_property("lcs_floundry").to_lower_case()}`); 
  if(item_amount($item[codpiece]).to_boolean()){
    use(1, $item[codpiece]);
    create(1, $item[Oil Cap]);
    autosell(1, $item[Oil Cap]);
  }
}

if(item_amount($item[portable pantogram]) > 0 && available_amount($item[pantogram pants]) == 0) {
	visit_url(`inv_use.php?which=3&whichitem=9573&pwd={my_hash()}`, false, true);
	// Mys, Hot res, MP, Spell, -Combat
  // &s2 = -1,0 for weapon damage or -2,0 for spell

	visit_url(`choice.php?pwd&whichchoice=1270&option=1&e=1&s1=-2,0&s2=-2,0&s3=-1,0&m=2`,true,true);
  
	cli_execute("refresh all");
}

print("Maximizing for mainstat buffs!", "teal");

if(have_effect($effect[Favored by Lyle]) == 0){
  maximize("mp", false);
}

if((!get_property("telescopeLookedHigh").to_boolean()) && (get_property("telescopeUpgrades") != "0")){
  cli_execute("up starry");
} //inb4 another effect beginning with 'starry' is introduced to the game and this breaks

if(!get_property("lyleFavored").to_boolean()){
  cli_execute("up lyle");
}

if(!get_property("_aprilShower").to_boolean()){
  cli_execute("shower lukewarm");
}

if (get_property("daycareOpen").to_boolean() && !get_property("_daycareSpa").to_boolean()){
  cli_execute("daycare " + to_lower_case(my_primestat()));

  if(get_property("_daycareGymScavenges").to_int() == 0){
    cli_execute("daycare scavenge free");
  }
}

if(get_property("lcs_use_nellyville") == "Yes"){
  catalog("nellyville");
}


print("Using a ten-percent bonus! (And bastille!)", "teal");

if(get_property("getawayCampsiteUnlocked").to_boolean() && !have_effect($effect[That's Just Cloud-Talk, Man]).to_boolean()){
  visit_url("place.php?whichplace=campaway&action=campaway_sky");
}

if(available_amount($item[A ten-percent bonus]).to_boolean()){
  use(1, $item[A ten-percent bonus]);
}

if((available_amount($item[Bastille Battalion control rig]).to_boolean()) && (!get_property("_bastilleGames").to_boolean())){
  cli_execute("bastille mainstat brutalist");
}

if(!storage_amount($item[Calzone of Legend]).to_boolean() && !get_property("calzoneOfLegendEaten").to_boolean() && !in_hardcore()){
  print("You don't have a calzone of legend in your Hagnk's. That's... not good.", "red");
  print("We're going to attempt to continue, after 25 seconds. This may fail for a variety of reasons.", "red");
  waitq(25);

  print("Pulling an pressurized potion of perspicacity instead...", "red");
  pull_item($item[pressurized potion of perspicacity]);
  use(1, $item[pressurized potion of perspicacity]);
} else if(!get_property("calzoneOfLegendEaten").to_boolean() && !in_hardcore()){
  if(have_effect($effect[Ready to eat]) == 0){
    print("Huh? We don't have ready to eat?", "red");
    print("That's weird, but we'll continue.", "red");
    waitq(5);
  }

  print("Pulling an calzone of legend...", "teal");
  take_storage(1,$item[calzone of legend]);
  eat(1, $item[Calzone of Legend]);
}

print("Restoring MP and buffing up myst!","teal");


if((available_amount($item[Magical sausage casing]) > 0) && (get_property("_sausagesEaten") == 0)){
  cli_execute("eat 1 magical sausage");
}

if((have_effect($effect[Tomes of Opportunity]) == 0) && (get_property("_spikolodonSpikeUses").to_int() > 0)){
  visit_url("adventure.php?snarfblat=528");
  run_choice(1); run_choice(2);
}

if(available_amount($item[beach comb]).to_boolean()) {
	get_effect($effect[You learned something maybe!]);
	get_effect($effect[Do I know you from somewhere?]);
}

if(item_amount($item[Powerful Glove]).to_boolean()){
  equip($slot[acc3], $item[Powerful Glove]);
}

foreach eff in $effects[Glittering Eyelashes, Triple-Sized, Feeling Excited, Feeling Peaceful, Feeling Nervous, Pride of the Puffin, Ur-Kel's Aria of Annoyance, Ode to Booze, Inscrutable Gaze, Big, Saucemastery, Carol of the Thrills, Spirit of Cayenne, Blood Bubble, Bendin' Hell, Confidence of the Votive, Drescher's Annoying Noise]{
  get_effect(eff);
}

if(get_property("lcs_use_birds") == "Before Powerleveling"){
  use_skill(1, $skill[Visit your Favorite Bird]);
}

if (get_property("_horsery") != "crazy horse"){
  cli_execute('horsery crazy');
}

if(my_class() == $class[Pastamancer] && my_thrall() == $thrall[None] && have_skill($skill[Bind Spice Ghost])){
  use_skill($skill[Bind Spice Ghost]);
}

if((have_effect($effect[On the Trolley]) == 0) && get_property("lcs_speakeasy_drinks").contains_text("Bee's Knees")){
  cli_execute("drink 1 bee's knees");
}
// TODO: Bird-a-day 

if(item_amount($item[potted power plant]).to_boolean()){
  visit_url(`inv_use.php?pwd&whichitem=10738`);
  foreach i, x in (get_property("_pottedPowerPlant").split_string(",")){
    if(x == "1"){
      visit_url(`choice.php?pwd&whichchoice=1448&option=1&pp={i.to_int() + 1}`);
    }
  }
}

visit_url("clan_viplounge.php?action=lookingglass&whichfloor=2");

if(get_property("_lcs_breakfast_complete") != "true"){
foreach it in $skills[Advanced Cocktailcrafting, Advanced Saucecrafting, Pastamastery, Perfect Freeze, Prevent Scurvy and Sobriety, Grab a Cold One, Summon Kokomo Resort Pass]{
  if(have_skill(it)){
    use_skill(it);
  }
}

// TODO: Hearts and love songs

}

set_property("_lcs_breakfast_complete", "true");
if(available_amount($item[Unbreakable Umbrella]).to_boolean()){
  cli_execute("umbrella broken");
}

if(have_effect($effect[Tainted Love Potion]) == 0 && have_skill($skill[Love Mixology])) {
  if(!available_amount($item[Love Potion #XYZ]).to_boolean()){
    use_skill(1, $skill[Love Mixology]);
  }
        
  visit_url('desc_effect.php?whicheffect=' + $effect[Tainted Love Potion].descid);
  if ($effect[Tainted Love Potion].numeric_modifier('mysticality') > 5 && $effect[Tainted Love Potion].numeric_modifier('muscle') > - 10 && $effect[Tainted Love Potion].numeric_modifier('moxie') > - 10){
    use(1, $item[Love Potion #XYZ]);
  }
}
  
if((!get_property('moonTuned').to_boolean()) && (my_sign() == "Wallaby") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) && (my_meat() > 2000)){
  retrieve_item(1, $item[Bitchin' Meatcar]);
  foreach sl in $slots[acc1, acc2, acc3]{
    if(equipped_item(sl) == $item[Hewn moon-rune spoon]){
      equip(sl, $item[none]);
    }
  }
	visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=8");
  cli_execute("MCD 10");
}

if(my_sign() == "Blender" && !have_effect($effect[Baconstoned]).to_boolean() && (!item_amount($item[Bitchin' Meatcar]).to_boolean() || !item_amount($item[Desert Bus Pass]).to_boolean())){
  
  if(!item_amount($item[vial of baconstone juice]).to_boolean() && item_amount($item[Baconstone]).to_boolean()){
    retrieve_item(1, $item[vial of baconstone juice]);
    use(1, $item[vial of baconstone juice]); 
  }
}

if(have_familiar($familiar[Melodramedary]) && have_skill($skill[Summon Clip Art]) && !available_amount($item[dromedary drinking helmet]).to_boolean()){
  clip_art($item[Box of Familiar Jacks]);
  use_familiar($familiar[Melodramedary]);
  use(1, $item[Box of Familiar Jacks]);
}

maximize("myst, 5 ML, 3 exp, 30 mysticality experience percent, 5 familiar exp, 8000 bonus designer sweatpants, 690 bonus tiny stillsuit, 90 bonus unbreakable umbrella, -equip i voted, -equip Kramco Sausage-o-Matic, 100 bonus Cincho de Mayo", false); 

if(my_hp() < my_maxhp()){
  cli_execute("hottub");
}

if(!have_effect($effect[Mystically Oiled]).to_boolean()){
  create(1, $item[Ointment of the Occult]);
  use(1, $item[Ointment of the Occult]);
}

if(available_amount($item[January's Garbage Tote]).to_boolean()){
  cli_execute("fold makeshift garbage shirt");
  equip($item[Makeshift Garbage Shirt]);
}

use_current_best_fam();

if(my_familiar() == $familiar[Melodramedary] && item_amount($item[dromedary drinking helmet]).to_boolean()){
  equip($slot[Familiar], $item[dromedary drinking helmet]);
} else if(familiar_equipped_equipment(my_familiar()) != $item[Tiny Stillsuit] && available_amount($item[Tiny Stillsuit]).to_boolean()){
  equip($slot[Familiar], $item[Tiny Stillsuit]);
}








string speakeasy_combat = "if hasskill sing along; skill sing along; endif; if monsterid 2252; if hasskill feel envy; skill feel envy; endif; endif; attack;";

if(get_property("ownsSpeakeasy").to_boolean() && get_property("_speakeasyFreeFights").to_int() < 3){

  if (have_skill($skill[Map the Monsters])){
    use_skill($skill[Map the Monsters]);

    visit_url("adventure.php?snarfblat=558");
    if (handling_choice() && last_choice() == 1435){
      run_choice(1, false, `heyscriptswhatsupwinkwink={$monster[Goblin Flapper].to_int()}`);

      run_combat("if hasskill sing along; skill sing along; endif; if monsterid 2252; if hasskill feel envy; skill feel envy; endif; endif; attack;");
      speakeasy_combat = "if hasskill sing along; skill sing along; endif; attack";
    } else { abort("We couldn't map properly...?"); }
  }


  while(get_property("_speakeasyFreeFights").to_int() < 3){
    adv1($location[An Unusually Quiet Barroom Brawl], -1, speakeasy_combat);
  }
}

familiar prev_fam = my_familiar();

if(((get_property("_godLobsterFights")) < 3) && have_familiar($familiar[God Lobster])){
  use_familiar($familiar[God lobster]);

  cli_execute("set choiceAdventure1310 = 3");

  for i from 0 to 2 {
    visit_url('main.php?fightgodlobster=1');
    
    run_combat("attack; skill saucegeyser; repeat !times 5");
    refresh();

    if((handling_choice()) || choice_follows_fight()){
      run_choice(3);
    }
  }

  use_familiar(prev_fam);
}

if(get_property("snojoAvailable").to_boolean()){
  visit_url("place.php?whichplace=snojo&action=snojo_controller");
  visit_url("choice.php?pwd&whichchoice=1118&option=3");
  while(get_property("_snojoFreeFights").to_int() < 10){
    use_current_best_fam();
    adv1($location[The X-32-F Combat Training Snowman], -1, "if hasskill curse of weaksauce; skill curse of weaksauce; endif; if hasskill sing along; skill sing along; endif; skill saucegeyser; skill saucegeyser; attack;");
  }
}

if((!have_effect($effect[Shadow Waters]).to_boolean() && (item_amount($item[closed-circuit pay phone]).to_boolean()))){
  string shadow_rift_combat = "if !haseffect 2698; if hasskill 7407 && !haseffect 2698; skill 7407; endif; endif; if hasskill 7297; skill 7297; endif; if hasskill curse of weaksauce; skill curse of weaksauce; endif; if !mpbelow 30; skill saucegeyser; endif; repeat !times 10; attack; repeat !times 10; abort";

  if(get_property("questRufus") == "unstarted"){

    set_property("choiceAdventure1497", "2");
    use(1, $item[closed-circuit pay phone]);
    /* Artifact, as boss is a bit annoying to kill. TODO */
  }

  while(have_effect($effect[Shadow Affinity]) > 0){

    boolean break_flag;

    use_current_best_fam();
    adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, shadow_rift_combat);

    if(handling_choice()){
      run_choice(-1);
    }
  }

  // Lodestone
  if(get_property("_shadowRiftCombats") == "11"){
    adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, shadow_rift_combat);
  }
}



if(get_property("lcs_rem_witchess_witch") == "Yes (Before Powerleveling)" && !available_amount($item[battle broom]).to_boolean()){
  print("Reminiscing that one time when you reincarnated as a witchess witch.","teal");

  if(my_hp() * 1.3 > my_maxhp()){
    cli_execute("hottub");
  }

  maximize("10 weapon damage, -1 mysticality, -10 ml, 1000 bonus fourth of may cosplay saber", false);

  visit_url("inventory.php?reminisce=1", false);
  visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1941");
  run_combat("sub LTS; if hasskill Lunging Thrust-Smack; skill Lunging Thrust-Smack; endif; endsub; call LTS; repeat !times 9; attack; repeat !times 9;");

  maximize("myst, 5 ML, 3 exp, 30 mysticality experience percent, 5 familiar exp, 8000 bonus designer sweatpants, 690 bonus tiny stillsuit, 90 bonus unbreakable umbrella, -equip i voted, -equip Kramco Sausage-o-Matic, 100 bonus Cincho de Mayo", false); 
}


// ghost yoked
if(have_familiar($familiar[Ghost of Crimbo Carols]) && !have_effect($effect[Holiday Yoked]).to_boolean() && !get_property("lcs_skip_yoked").to_boolean()){
  use_familiar($familiar[Ghost of Crimbo Carols]);
}

if(available_amount($item[Autumn-aton]).to_boolean()){
  cli_execute("autumnaton send The Neverending Party");
}

boolean yoked_obtained = false;
string nep_powerlevel = "if hasskill 7486; skill 7486; endif; if hasskill feel pride; skill feel pride; endif; if hasskill curse of weaksauce; skill curse of weaksauce; endif; if hasskill sing along; skill sing along; endif; if hasskill 7444; if hasskill Stuffed Mortar Shell; if hasskill shadow noodles; skill shadow noodles; endif; skill Stuffed Mortar Shell; skill 7444; endif; endif; skill saucegeyser; skill saucegeyser; attack; repeat !times 10; abort;";
string nep_freerun_sideways = `skill bowl sideways; {freerun}; abort`;
string nep_powerlevel_freekills = "if hasskill sing along; skill sing along; endif; if hasskill chest x-ray; skill chest x-ray; endif; if hasskill shattering punch; skill shattering punch; endif; if hasskill gingerbread mob hit; skill gingerbread mob hit; endif; if hasskill shocking lick; skill shocking lick; endif; if hascombatitem groveling gravel; use groveling gravel; endif; abort;";
set_property("choiceAdventure1324", 5);
while(get_property("_neverendingPartyFreeTurns").to_int() <= 9){
  adv1($location[The Neverending Party], -1, nep_powerlevel);

  if((!have_effect($effect[\[1701\]Hip to the Jive]).to_boolean()) && (my_meat() >= 5000) && get_property("lcs_speakeasy_drinks").contains_text("Hot Socks")){
    cli_execute("drink 1 hot socks");
  }
    
  if(my_familiar() == $familiar[Ghost of Crimbo Carols] && have_effect($effect[Holiday Yoked]).to_boolean()){
    yoked_obtained = true;
  }

  if(yoked_obtained || !have_familiar($familiar[Ghost of Crimbo Carols])){
    use_current_best_fam();
  }

  if(my_familiar() == $familiar[Melodramedary] && available_amount($item[dromedary drinking helmet]).to_boolean() && equipped_item($slot[Familiar]) != $item[dromedary drinking helmet]){
    equip($item[dromedary drinking helmet]);
  }


  if(visit_url("place.php?whichplace=chateau").contains_text(`Rest in Bed (free)`) && get_property("_cinchUsed") <= 70){
    visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");
  }

  if(my_hp() * 3 < my_maxhp()){
    restore_hp(my_maxhp());
  }

  if(have_effect($effect[Beaten Up]).to_boolean()){
    abort("We got beaten up =(");
  }
  
  if(get_property("cosmicBowlingBallReturnCombats") == 0){
    adv1($location[The Neverending Party], -1, nep_freerun_sideways);
  }
}


// Saves one just in case


// If someone has daily affirmations I think they're off running a better script then this
item pre_freekill_acc3 = equipped_item($slot[Acc3]);

if(item_amount($item[Lil' Doctor&trade; bag]).to_boolean()){
  equip($slot[acc3], $item[Lil' Doctor&trade; bag]);
}

int freekills = get_all_freekills() - 1;
print(`Running {freekills} freekill{is_plural(freekills)} in the NEP!`,"teal");

while(freekills > 0){

  if((!have_effect($effect[\[1701\]Hip to the Jive]).to_boolean()) && (my_meat() >= 5000) && get_property("lcs_speakeasy_drinks").contains_text("Hot Socks")){
    cli_execute("drink 1 hot socks");
  }
    
  if((my_mp() < 80) && (item_amount($item[Magical Sausage Casing]) > 0)){
    cli_execute("eat magical sausage");
  }

  if(get_property("cosmicBowlingBallReturnCombats") == 0){
    adv1($location[The Neverending Party], -1, nep_freerun_sideways);
  }
  
  adv1($location[The Neverending Party], -1, nep_powerlevel_freekills);
  use_current_best_fam();

  if(get_property("garbageShirtCharge") < 2 && equipped_amount($item[Makeshift Garbage Shirt]).to_boolean()){
    equip($slot[Shirt], $item[none]);
  } // TODO: post-adv script

  freekills--;
  print(`{freekills} freekill{is_plural(freekills)} left!`,"teal");
}

equip($slot[acc3], pre_freekill_acc3);

string nep_powerlevel_backup = "if hasskill Back-Up to your Last Enemy; skill Back-Up to your Last Enemy; endif; if hasskill sing along; skill sing along; endif; if hasskill 7444; if hasskill Stuffed Mortar Shell; if hasskill shadow noodles; skill shadow noodles; endif; skill Stuffed Mortar Shell; skill 7444; endif; endif; if hasskill curse of weaksauce; skill curse of weaksauce; endif; skill saucegeyser; repeat !times 2";
equip($item[Kramco Sausage-o-Matic&trade;]);

if(!contains_text(get_property("lastEncounter"), "sausage goblin")){
  if(my_hp() < my_maxhp()){
    cli_execute("hottub");
  }

  print("Fighting a sausage goblin from the Kramco!","teal");

  if(get_property("_sausageFights") == 1){
  
    if(get_property("lcs_prof_lecture") == "Yes" && get_property("_pocketProfessorLectures") == "0" && have_familiar($familiar[Pocket Professor])){
      print("And using your pocket professor to chain the sausage goblin!", "teal");
      use_familiar($familiar[Pocket Professor]);
      foreach it in $effects[Empathy, Leash of Linguini, Blood Bond]{
        get_effect(it);
      }

      adv1($location[The Neverending Party], -1, `if hasskill lecture on relativity; skill lecture on relativity; endif; {nep_powerlevel}`);
      while(in_multi_fight()){
        run_combat(`if hasskill micrometeorite; skill micrometeorite; endif; if hasskill lecture on relativity; skill lecture on relativity; endif; {nep_powerlevel}`);
      }
    } else {
      adv1($location[The Neverending Party], -1, nep_powerlevel);
    }
  } 
}





use_current_best_fam();
int backup_uses = get_property(`lcs_alloted_backup_uses`).to_int();

if(backup_uses != 0){
  print("Now backing up your fights!","teal");
  // TODO: Only swap if not equipped
  equip($slot[acc3], $item[Backup Camera]);
  if(get_property("lastCopyableMonster") != "sausage goblin"){
    abort("We're heading into our backup chain without a sausage goblin as the last monster fight!");
  }

  while(get_property("_backUpUses").to_int() < (backup_uses - 3)){
    adv1($location[The Neverending Party], -1, nep_powerlevel_backup);
    use_current_best_fam();

  }

  if(get_property("lastEncounter") != "Witchess Bishop" && get_property("lcs_rem_witchess_witch") == "No"){
    print("Reminiscing that one time when you reincarnated as a witchess bishop.","teal");

    visit_url("inventory.php?reminisce=1", false);
    visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1942");
    run_combat(nep_powerlevel);

    print("Now fighting 3 backed up Witchess Bishops!", "teal");
  } 

  

  while(get_property("_backUpUses").to_int() < backup_uses){
    adv1($location[The Neverending Party], -1, nep_powerlevel_backup);
    use_current_best_fam();
  }
}


if(my_id() == 3272033 && get_property("_shortOrderCookCharge").to_int() >= 9){
  foreach num in $strings[8, 22]{
    if(!get_property(`_aug{num}Cast`).to_boolean()){
	    visit_url(`runskillz.php?action=Skillz&whichskill={7451 + num.to_int()}&targetplayer=${my_id()}&pwd=&quantity=1`);
      run_combat("skill saucegeyser; repeat !times 2; attack; repeat !times 3;");
    }
  }
}

}

void mys_test(){

maximize("mys, switch left-hand man", false); 

cs_test(3);
}


void mox_test(){ 
if(!have_effect($effect[Expert Oiliness]).to_boolean()){
  retrieve_item($item[Oil of Expertise]);
  use(1, $item[Oil of Expertise]);
}

maximize("mox, switch left-hand man", false); 

cs_test(4);
}

void mus_test(){
maximize("mus, switch left-hand man", false); 

cs_test(2);
}

void hp_test(){
maximize("hp, switch left-hand man", false); 

cs_test(1);

if(my_sign() == "Blender"){
  cli_execute("mcd 0");
}

}



void item_test(){

if(familiar_equipped_equipment(my_familiar()) != $item[Tiny Stillsuit] && available_amount($item[Tiny Stillsuit]).to_boolean()){
  equip($slot[Familiar], $item[Tiny Stillsuit]);
}

get_shadow_waters();

if(get_property("lcs_use_birds") == "During Item Test"){
  use_skill(1, $skill[Visit your Favorite Bird]);
}

set_location($location[The Sleazy Back Alley]);
set_property("lastAdventure", "");
use_familiar($familiar[Mosquito]);

if(have_familiar($familiar[Disgeist])){
  use_familiar($familiar[Disgeist]);
}

if (item_amount($item[mumming trunk]) > 0) {
	cli_execute('try; mummery item');
}

if(!have_effect($effect[One Very Clear Eye]).to_boolean() && get_property("lcs_get_cyclops_eyedrops") == "yes"){
  print("Getting eyedrops!", "teal");
  retrieve_item($item[11-Leaf Clover]);
  use(1, $item[11-Leaf Clover]);
  adv1($location[The Limerick Dungeon],  -1, lcs_abort);
  refresh();
  use(1, $item[Cyclops eyedrops]);
}

if(get_property("sourceTerminalEducateKnown") != ""){
  get_effect($effect[items.enh]);
}

maximize("item, booze drop, -equip broken champagne bottle, switch left-hand man", false); 


if((my_inebriety() < 7) && (item_amount($item[Sacramento Wine]) > 0)){
  use_skill(1, $skill[The Ode to Booze]);

  if(item_amount($item[Sacramento wine]).to_boolean()){
    drink(1, $item[Sacramento wine]);
  }


  if(available_amount($item[Tiny Stillsuit]).to_boolean()){
    cli_execute("drink stillsuit distillate");
  }
} 



refresh();

cs_test(9);

}


void fam_weight_test(){

if(item_amount($item[Deep dish of Legend]).to_boolean()){
  eat(1, $item[Deep dish of Legend]);
}

if(item_amount($item[Burning newspaper]).to_boolean()){
  retrieve_item($item[Burning paper crane]);
}

if(get_property("commaFamiliar") == "Homemade Robot"){
  use_familiar($familiar[Comma Chameleon]);
  visit_url("charpane.php");
}


if(have_familiar($familiar[Comma Chameleon]).to_boolean() && have_familiar($familiar[Homemade Robot]).to_boolean() && get_property("commaFamiliar") != "Homemade Robot"){
  print("Pulling/creating some homemade robot gear!", "teal");

  if(!in_hardcore()){ 
    if(!clip_art($item[Box of Familiar Jacks])){
      item gear = $item[Homemade Robot Gear];

      if(mall_price($item[Box of Familiar Jacks]) < mall_price($item[Homemade robot gear])){
        gear = $item[Box of Familiar Jacks];
      }
      pull_item(gear);
    }

  } else {
    clip_art($item[Box of Familiar Jacks]);
  }

  if(item_amount($item[Box of familiar jacks]) > 0 && item_amount($item[Homemade Robot Gear]) == 0){
    use_familiar($familiar[Homemade Robot]);
    use(1, $item[Box of Familiar jacks]);
    use_familiar($familiar[Comma Chameleon]);
    visit_url("inv_equip.php?which=2&action=equip&whichitem=6102&pwd");
    visit_url("charpane.php");
    refresh();
  }

}

foreach it in $effects[Leash of Linguini, Blood Bond, Empathy, Ode to Booze, Loyal as a Rock]{
  get_effect(it);
}

if(!have_effect($effect[Billiards Belligerence]).to_boolean()){
  cli_execute("up Billiards Belligerence");
}

if(get_property("lcs_hatter_buff") == "Familiar Weight"){
  cli_execute("try; hatter 24");
}
// TODO: Maybe add sparkler hat from VIP?
  
meteor_shower();

if(available_amount($item[Eight Days a Week Pill Keeper]).to_boolean() && !have_familiar($familiar[Comma Chameleon]) && !have_effect($effect[Fidoxene]).to_boolean()){
  cli_execute("pillkeeper familiar");
}



if(!item_amount($item[overloaded Yule battery]).to_boolean() && have_familiar($familiar[Mini-Trainbot]) && have_skill($skill[Summon Clip Art]) && !have_familiar($familiar[Comma Chameleon])){
  clip_art($item[Box of Familiar Jacks]);
  use_familiar($familiar[Mini-Trainbot]);
  use(1, $item[Box of Familiar Jacks]);
}

// TODO: Integrate this with the effect thing, maybe as a seperate function
if(item_amount($item[overloaded Yule battery]).to_boolean() && have_familiar($familiar[Mini-Trainbot])){
  use_familiar($familiar[Mini-Trainbot]);
  equip($item[overloaded Yule battery]);
} else {
  int max_familiar_weight;
  familiar max_famwt_familiar;

  foreach it in $familiars[]{
    if(max_familiar_weight < familiar_weight(it) && it != $familiar[Homemade Robot]){
      max_familiar_weight = familiar_weight(it);
      max_famwt_familiar = it;
    }
  }

  use_familiar(max_famwt_familiar);
}



// Property doesn't get updated on visit_url sometimes. This'll solve it, but may induce trouble later on =(
if(get_property("commaFamiliar") == "Homemade Robot" || (have_familiar($familiar[Comma Chameleon]) && have_familiar($familiar[Homemade Robot]))){
  use_familiar($familiar[Comma Chameleon]);
  visit_url("charpane.php");
}

maximize("Familiar weight", false);

cs_test(5);

if(get_property("lcs_august_scepter") == "Offhand Remarkable After Familiar Weight Test"){
  august_scepter(13);
}

}


void hot_res_test(){

if((available_amount($item[Industrial Fire Extinguisher]).to_boolean()) && (available_amount($item[Fourth of May Cosplay Saber]).to_boolean()) && (!have_effect($effect[Fireproof Foam Suit]).to_boolean())){
  
  string saber_foam = "if hasskill Mist Form; skill mist form; endif; skill Fire Extinguisher: Polar Vortex; skill Fire Extinguisher: Foam Yourself; skill Use the Force;";

  if(test){
    saber_foam = "if hasskill Mist Form; skill mist form; endif; skill Fire Extinguisher: Foam Yourself; skill Use the Force;";
  } 
   
  print("Also fighting a ungulith to save a freekill!", "teal"); 
  equip($slot[Weapon], $item[Industrial Fire Extinguisher]);
  equip($slot[Off-hand], $item[Fourth of May Cosplay Saber]);

  refresh();
  use_current_best_fam();


  if(my_adventures() == 0){
    gain_adventures(0); // this works since I add a +1 in the function itself =\
  }

  visit_url("inventory.php?reminisce=1", false);
  visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1932");
  
  refresh();
  run_combat(saber_foam);

  run_choice(3);
}

if(have_familiar($familiar[Exotic Parrot])){
  use_familiar($familiar[Exotic Parrot]);
} else if(have_familiar($familiar[Mu])){
  use_familiar($familiar[Mu]);
}


if(!have_effect($effect[Fireproof Foam Suit]).to_boolean()){

  if(get_property("_photocopyUsed").to_boolean()){
    abort("Uh-oh, you've already used the fax!");
  }
  string spit = "if hasskill Become a Cloud of Mist; skill Become a Cloud of Mist; endif; if hasskill shocking lick; skill shocking lick; endif; skill spit Jurassic Acid; abort";

  equip($item[Jurassic Parka]);
  cli_execute("parka dilophosaur");


  if (available_amount($item[photocopied monster]) == 0) {
    chat_private("Cheesefax", "Factory Worker");
    for i from 1 to 3 {
      wait(6);
      cli_execute("fax receive");

      if (get_property("photocopyMonster") != "factory worker") {
        cli_execute("fax send");
      }
    }
  }

  if (available_amount($item[photocopied monster]) == 0 && (get_property("photocopyMonster") != "Factory Worker")){
    abort("Failed to get a Factory Worker fax. Cheesefax may be offline or another person may have been using the fax. Try manually and rerun");
  }

  visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=4873`);
  run_combat(spit);
}


maximize("hot res", false);

cs_test(10);

}

void non_combat_test(){

if(my_id() == 3272033){
  equip($item[Cincho de Mayo]);
  get_effect($effect[Party Soundtrack]);
}

get_shadow_waters();

if(have_familiar($familiar[Disgeist])){
  use_familiar($familiar[Disgeist]);
}

if(!available_amount($item[porkpie-mounted popper]).to_boolean()){
  buy(1, $item[Porkpie-mounted popper]); 
}

if(get_property("lcs_august_scepter") == "Offhand Remarkable Before Non-Combat Test"){
  august_scepter(13);
}

maximize('-100 combat, familiar weight', false);


// For list of effects, look at LCSWrapperResources.ash

cs_test(8);
}

void weapon_damage_test(){ 

if(available_amount($item[Songboom&trade; Boombox]) > 0 && get_property("boomBoxSong") != "These Fists Were Made for Punchin\'"){
	cli_execute("Boombox damage");
}

// TODO: Inner Elf =\

if(get_property("lcs_use_birds") == "During Weapon or Spell Damage Test"){
  if(get_property("_birdOfTheDayMods").contains_text("Weapon")){
    use_skill(1, $skill[Visit your Favorite Bird]);
  }
}


if((have_familiar($familiar[Melodramedary])) && (get_property("camelSpit") == 100) && !have_effect($effect[Spit upon]).to_boolean()){
  print("Getting spit on!", "teal");
  use_familiar($familiar[Melodramedary]);
  string spit_on_me = `skill 7340; endif; if hasskill bowl a curveball; skill bowl a curveball; endif; {freerun}`;
  adv1($location[The Neverending Party], -1, spit_on_me);
}

if(have_effect($effect[Holiday Yoked]).to_boolean()){
  set_property("lcs_skip_yoked", "true");
}

if(have_familiar($familiar[Ghost of Crimbo Carols]) && !have_effect($effect[Do You Crush What I Crush?]).to_boolean() && !have_effect($effect[Holiday Yoked]).to_boolean()){
  print("Getting Do You Crush What I Crush?", "teal");

  use_familiar($familiar[Ghost of Crimbo Carols]);

  if(item_amount($item[Kramco Sausage-o-Matic&trade;]).to_boolean()){
    equip($item[Kramco Sausage-o-Matic&trade;]);
  }

  if(have_effect($effect[Feeling Lost]).to_boolean()){
    abort("We have feeling lost... Maybe fax a sausage goblin?");
  } 

  adv1($location[The Outskirts of Cobb's Knob], -1, `if monsterid 2104; skill saucegeyser; endif; {freerun}; abort;`);

}

if((have_skill($skill[Deep Dark Visions])) && (!have_effect($effect[Visions of the Deep Dark Deeps]).to_boolean())){
	get_effect($effect[Elemental saucesphere]);
	get_effect($effect[Astral shell]);
	maximize("1000 spooky res, hp, mp, switch left-hand man", false);
  cli_execute("hottub");
  use_skill(1, $skill[Deep Dark Visions]);
}

if(!have_effect($effect[Cowrruption]).to_boolean()){
  use(1, $item[Corrupted Marrow]);
}

if(!have_effect($effect[Billiards Belligerence]).to_boolean()){
  cli_execute("pool 1");
}

if (available_amount($item[beach comb]) > 0 && !have_effect($effect[Lack of body-building]).to_boolean()){
	get_effect($effect[Lack of body-building]);
}


// TODO: Kung fu hustler lmao? +45 flat

if(pulls_remaining() > 0 && my_class() == $class[Pastamancer] && storage_amount($item[Stick-knife of Loathing]).to_boolean() && have_skill($skill[Bind Undead Elbow Macaroni])){
  
  foreach i, o_name in get_custom_outfits(){
    if(o_name.to_lower_case() == "stick-knife"){
        take_storage(1, $item[Stick-knife of Loathing]);
        use_skill(1, $skill[Bind Undead Elbow Macaroni]);
        outfit(o_name);
        break;
    }
  }
  
  if(storage_amount($item[Stick-knife of Loathing]).to_boolean() && available_amount($item[Stick-knife of Loathing]) == 0){
  
  foreach x, outfit_name in get_custom_outfits()

    foreach x,piece in outfit_pieces(outfit_name)

      if(piece.contains_text("Stick-Knife of Loathing")){
        print(`Outfit '{outfit_name}' has a {piece} in it! Pulling a stick-knife and trying to equip that outfit...`, "teal");

        take_storage(1, $item[Stick-knife of Loathing]);
        use_skill(1, $skill[Bind Undead Elbow Macaroni]);
        outfit(outfit_name);
        break;
      } 
      
      if(!equipped_amount($item[Stick-knife of Loathing]).to_boolean()){
        print("Uh-oh, you don't have an outfit with a knife in it! Make one after the run finishes!", "red");
      }
  }

}

if((my_meat() > 1000) && !(get_property("_madTeaParty")).to_boolean() && get_property("lcs_hatter_buff") == "Weapon Damage"){
  retrieve_item($item[goofily-plumed helmet]);
  cli_execute("hatter 20");
}

if((!item_amount($item[Red Eye]).to_boolean()) && available_amount($item[Combat Lover's Locket]).to_boolean() && (get_property("lcs_get_red_eye") != "No")){
  print("Reminiscing a red skeleton!","teal");

  if(!have_effect($effect[Everything Looks Yellow]).to_boolean()){
    item prev_shirt = equipped_item($slot[Shirt]);

    equip($item[Jurassic Parka]);
    cli_execute("Parka dilophosaur");

    visit_url("inventory.php?reminisce=1", false);
    visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1521");

    refresh();
    run_combat("skill spit jurassic acid; abort;");
    equip($slot[Shirt], prev_shirt);
  } else if (have_skill($skill[Shocking Lick])){
    visit_url("inventory.php?reminisce=1", false);
    visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1521");

    run_combat("skill shocking lick; abort;");

  }
  if(item_amount($item[Red eye]).to_boolean())
    use(1, $item[Red eye]);

}

if((!get_property('moonTuned').to_boolean()) && (my_sign() == "Wallaby") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) && (my_meat() > 2000)){
  retrieve_item(1, $item[Bitchin' Meatcar]);
  foreach sl in $slots[acc1, acc2, acc3]{
    if(equipped_item(sl) == $item[Hewn moon-rune spoon]){
      equip(sl, $item[none]);
      break;
    }
  }
	visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=8");

  refresh();
}

if(my_sign() == "Blender" && !have_effect($effect[Engorged Weapon]).to_boolean() && ((item_amount($item[Bitchin' Meatcar]).to_boolean()) || (item_amount($item[Desert Bus Pass]).to_boolean()))){
  retrieve_item(1, $item[Meleegra&trade; pills]);
  use(1, $item[Meleegra&trade; pills]);
}


if(my_inebriety() <= 13 && get_property("lcs_speakeasy_drinks").contains_text("Sockdollager")){
  use_skill(1, $skill[The Ode to Booze]);
  cli_execute("drink 1 Sockdollager");
}

if(have_familiar($familiar[Left-hand Man])){
  use_familiar($familiar[Left-hand Man]);
}

// Maximizer not knowing what to do with a stick-knife fix
foreach it in $slots[weapon, off-hand, familiar]{
  equip(it, $item[none]);
}
meteor_shower();

maximize("Weapon damage percent, weapon damage, switch left-hand man", false);
equip_stick_knife();




cs_test(6);
}



void spell_damage_test(){

if(get_property("lcs_use_birds") == "During Weapon or Spell Damage Test"){
  if(get_property("_birdOfTheDayMods").contains_text("Spell")){
    use_skill(1, $skill[Visit your Favorite Bird]);
  }
}

if(get_property("lcs_rem_witchess_witch") == "Yes (Before spell damage test)" && !available_amount($item[battle broom]).to_boolean()){
  print("Reminiscing that one time when you reincarnated as a witchess witch.","teal");

  if(my_hp() * 1.3 > my_maxhp()){
    cli_execute("hottub");
  }

  maximize("10 weapon damage, -1 mysticality, -10 ml, 1000 bonus fourth of may cosplay saber, -equip combat lover's locket", false);
  refresh();
  visit_url("inventory.php?reminisce=1", false);
  visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1941");
  run_combat("sub LTS; if hasskill Lunging Thrust-Smack; skill Lunging Thrust-Smack; endif; endsub; call LTS; repeat !times 9; attack; repeat !times 9;");
}


if(my_adventures() < 2){
  gain_adventures(1);
}

if(!have_effect($effect[Simmering]).to_boolean() && have_skill($skill[Simmer]) && (have_effect($effect[Spit upon]) != 1)){
  use_skill(1, $skill[Simmer]);
}

if((have_skill($skill[Deep Dark Visions])) && (!have_effect($effect[Visions of the Deep Dark Deeps]).to_boolean())){
  get_effect($effect[Elemental saucesphere]);
  get_effect($effect[Astral shell]);
  maximize("1000 spooky res, hp, mp, switch left-hand man", false);
  restore_hp(800);
  use_skill(1, $skill[Deep Dark Visions]);
}

if(available_amount($item[beach comb]) > 0 && !have_effect($effect[We're all made of starfish]).to_boolean()){
  get_effect($effect[We're all made of starfish]);
}

if(!have_effect($effect[Cowrruption]).to_boolean()){
  use(1, $item[Corrupted Marrow]);
}

if((my_meat() > 1000) && !(get_property("_madTeaParty")).to_boolean() && get_property("lcs_hatter_buff") == "Spell Damage"){
  retrieve_item($item[mariachi hat]);
  cli_execute("hatter 11");
}

meteor_shower();

foreach it in $effects[AAA-Charged, Carol of the Hells, Spirit of Peppermint, Song of Sauce]{
  get_effect(it);
}

if(item_amount($item[fudge-shaped hole in space-time]).to_boolean()){
  use(1, $item[fudge-shaped hole in space-time]);
}

if(!have_effect($effect[Mental A-cue-ity]).to_boolean()){
  cli_execute("pool 2");
}

if(pulls_remaining() > 0 && !alice_army_snack($effect[Pisces in the Skyces])){

  pull_item($item[Tobiko marble soda]);
  use(1, $item[Tobiko marble soda]);
}

// TODO: Preference for paw/wish uses
if(my_id() == "3272033"){
  foreach eff in $strings[Sparkly!, Witch Breaded, Pisces in the Skyces, Celestial Mind]{
    if(get_property("_monkeyPawWishesUsed") < 4 && get_property("_monkeyPawWishesUsed") != 0){
      wish_effect(eff);
    }
  }
}


cargo_effect($effect[Sigils of Yeg]);

if(pulls_remaining() > 0){ // TODO: Priority for spell damage stuff if pulls are remaning
  abort("We still have some pulls remaining! Consider setting preference `lcs_autopull_at_start` to pull extra items automatically at the start!");
}

maximize("Spell damage, spell damage percent, switch left-hand man", false);



equip_stick_knife();
cs_test(7);
}

void donate_body_to_science(){
  visit_url("choice.php?whichchoice=1089&option=30&pwd");
  cli_execute("refresh all");

  print("Emptying your storage!", "teal");
  visit_url("storage.php");
  cli_execute("hagnk all");

  refresh();
  if(available_amount($item[Beach Comb]).to_boolean()){
    cli_execute(`try; combo {11 - get_property("_freeBeachWalksUsed").to_int()}`);
  }
  cli_execute("make calzone of legend");

  if(available_amount($item[Songboom&trade; Boombox]) > 0 && get_property("boomBoxSong") != "Food Vibrations"){
	  cli_execute("Boombox food");
  }
  
  if(!item_amount($item[Bitchin' Meatcar]).to_boolean() && !item_amount($item[Desert Bus Pass]).to_boolean()){
    cli_execute("make bitchin' meatcar");
  }

  if(available_amount($item[designer sweatpants]).to_boolean()){
    int booze_casts = min(3, min(my_inebriety(), floor(get_property("sweat").to_int() / 25)));
    cli_execute(`{(booze_casts) == 0 ? "" : `cast {booze_casts} sweat out some booze`}`);
  }

  if(have_skill($skill[Lock Picking]).to_boolean()){
    use_skill($skill[Lock Picking]); 
    run_choice(1);
  }

  
  cli_execute("breakfast");

  if(get_property("autumnatonUpgrades") == "" && item_amount($item[autumn-aton]).to_boolean()){
    cli_execute("autumnaton upgrade");
  }

  if(item_amount($item[Model train set]).to_boolean()){
    if(visit_url("campground.php?action=workshed",false,true).contains_text('value="Save Train Set Configuration"')){
      visit_url("choice.php?forceoption=0&whichchoice=1485&option=1&pwd&slot[0]=8&slot[1]=1&slot[2]=7&slot[3]=20&slot[4]=15&slot[5]=19&slot[6]=2&slot[7]=4", true);
      refresh();
    }
  }
}

void sekrit(){ // ;)
  abort();
}

void test(string test_name){
  set_property(`lcs_pre_test_info_{test_name}`, `{turns_played()} | {now_to_int()}`);

  string which_test = test_name + "_test";
  call void which_test();

  set_property(`lcs_post_test_info_{test_name}`, `{turns_played()} | {now_to_int()}`);
  /* indiv_test_info : [0] => pre test turn amount. [1] => pre test time. [2] => post test turn amount. [3] => post test time. */
  string [int] indiv_test_info = split_string(`{get_property(`lcs_pre_test_info_{test_name}`)} | {get_property(`lcs_post_test_info_{test_name}`)}`, " \\| ");

  print(`We took {(indiv_test_info[3].to_int() - indiv_test_info[1].to_int())/1000} seconds and {(indiv_test_info[2].to_int() - indiv_test_info[0].to_int())} adventure{is_plural((indiv_test_info[3].to_int() - indiv_test_info[1].to_int()))} {flavour_text(test_name)}}`, "lime");

}



// TODO: Have the script set your recovery/other options and revert them at run end
void main(string... settings){
  
string[int] options = settings.join_strings(" ").split_string(" ");

boolean[string] available_choices;
foreach it in $strings[
  help,
  ascend,
  start,
  setup,

  skipleveling,
  powerlevel,

  test,
  summary,
  sekrit,
] available_choices[it] = false;

string current_script_ver = "v1.43";
if(get_property("lcs_start") != current_script_ver){

  newline();

  if(get_property("lcs_start") == ''){ // No property
    print("Hello! Thanks for running this script for the first time!");
    print("Since this is your first and only time you'll see this screen, we've set a couple of settings for you.");
    print("If you ever want to adjust these changes, please run the help command!");

    newline();

    if(have_familiar($familiar[Pair of Stomping Boots])){
      set_property("lcs_use_beta_version", "true");
    }

    if(get_property("goorbo_clan") != ""){
      set_property("lcs_clan", get_property("goorbo_clan"));
    }

    set_property("lcs_start", current_script_ver);
    abort("Please run the script again to continue!");
  }

  if(!get_property("lcs_start").contains_text('v1.4')){ 
    print(`Thanks for updating the script! There's been a few large changes done since you last updated.`, "teal");
    newline();
    print("As such, we're going to nuke all your delicate hand-crafted preferences. Sorry, no hard feelings.");
    waitq(3);
    foreach it in get_all_properties("", false){
      if(it.substring(0, 3) == "lcs"){
        set_property(it, "");
        remove_property(it, false);
      }
    }
    
    set_property("lcs_start", current_script_ver);
    print("Please run `lcswrapper setup` to restore them!", "orange");
    newline();
  }

  print(`Welcome back, {my_name()}! Here's what changed:`, "teal");

  print("- Chateau desk is harvested, cowboy boots are harvested, detective badge is harvested");
  print("- Bird-a-day is now mostly supported");
  print("- Fortune consults are supported for those in clans 'The Average Clan' and 'Bonus Adventures from Hell'");
  print("  If your clan has a fortune bot and isn't in the above, ping me on discord to get it added!");
  print("- More safeguards. Always good");
  print("- 2002 is now pretty much fully supported, I'd say?");
  print("- Added Patriotic Eagle support, as well as Cloake support (if you have said eagle)");
  print("- Additional forms of meat via autosell (oil cap/kokomo) are added. Will add more soon");

  print("- Pull revamp soon™️");

  // TODO: Prefrence for cookbookbat usage, trainbot support? /shrug
  newline();
  set_property("lcs_start", current_script_ver);
  newline();

  wait(10);
}

newline();

foreach key in options {  
  /* print(options[key], "green"); */
  
  foreach it in available_choices{
    if(contains_text(to_lower_case(options[key].to_string()), it)){
      print(`Running option: {it}`, "green");
      available_choices[it] = true;
    }
  }
}
newline();

if(available_choices["test"] || get_property("lcs_use_beta_version").to_boolean()){
  print("Entering test mode! Thanks for helping to test!", "lime");
  test = true;
  newline();
  if(available_choices["sekrit"]){
    sekrit();
  }
}

if(available_choices["help"]){

  print_html("<font size=4><b><font color=D3D3D3><center> Help: </center><font></b></font>");
  print_html("<center><font color=d3d3d3> Contrary to the 'Wrapper' name, this is a CS script that will finish a SCCS run as a Sauceror under any moon! </font></center>");
  newline();
  print_html("<font size=4><b><font color=D3D3D3><center> Options: </center><font></b></font>");
  print_html("<p><center><font color=66b2b2>skipleveling</font><font color=d3d3d3> - This will skip powerleveling, if you encounter a bug and cannot continue during powerleveling.</font></center></p>");
  print_html("<p><br><center><font color=66b2b2>summary</font><font color=d3d3d3> - This outputs a summary of your last recorded run, including turns used and time taken. </font></center></p>");
  print_html("<p><br><center><font color=66b2b2>help</font><font color=d3d3d3> - This displays this window! Yay!. </font></center></p>");
  print_html("<p><br><center><font color=66b2b2>setup</font><font color=d3d3d3> - Need to modify or adjust the script? Run this setting! </font></center></p>");
  print_html("<p><br><center><font color=66b2b2>sim</font><font color=d3d3d3> - Check if you can run the script. </font></center></p>");
  print_html("<p><br><center><font color=66b2b2>test</font><font color=d3d3d3> - I'll add brand-new features for higher-shiny accounts for beta-testing! Thanks for helping with debugging!.</font></center></p>");

  abort("");
}

if(available_choices["summary"]){
  summary(true);
  abort("");
}

if(available_choices["setup"]){
  script_setup();
  abort("");
}

if(get_property("lcs_turn_threshold_mys") == ""){
  print("It looks like your script preferences haven't been set or are incorrectly set!", "red");
  print("We're going to run `lcswrapper setup` in 10 seconds in order to restore them!", "red");
  waitq(10);
  script_setup();
  abort("Rerun the script!");
}


if((visit_url("charpane.php").contains_text("Astral Spirit")) || available_choices["ascend"]){
  ascend();
}

if(my_path().id != 25){
  abort("We're not in Community Service! If you want a summary of last run, type 'lcswrapper summary'!");
}

// 30m has passed since you last ran it. Maybe use prop. ascensionsToday?
if(get_property("lcs_time_at_start").to_int() + 1800000 < now_to_int()){
  set_property("lcs_time_at_start", now_to_int());
}

string prev_ccs = get_property('customCombatScript');
string clan_at_start = get_clan_name();
if(get_property("lcs_clan") != ""){
  cli_execute(`/whitelist {get_property("lcs_clan")}`);
}
  buffer ccs;

  ccs.append("[default]");
  ccs.append("\n");
  ccs.append("consult LCSWrapperCombat.ash");

  write_ccs(ccs, "lcswrapper_combat_script");
  set_property('customCombatScript',"lcswrapper_combat_script");


if(available_amount($item[astral six-pack]).to_boolean()){
  oriole();
  set_property("post_time_oriole", now_to_int());
  set_property("post_advs_oriole", turns_played());
  print("We took "+((get_property("post_time_oriole").to_int() - get_property("lcs_time_at_start").to_int())/1000)+" seconds and "+(get_property("post_advs_oriole").to_int())+" adventure(s) completing post-ascension tasks!", "lime");
}

if(!contains_text(get_property("csServicesPerformed"), "Coil Wire")){
  coil_wire();
  set_property("post_time_wire", now_to_int());
  set_property("post_advs_wire", turns_played());
  print("We took "+((get_property("post_time_wire").to_int() - get_property("post_time_oriole").to_int())/1000)+" seconds and "+(get_property("post_advs_wire").to_int() - get_property("post_advs_oriole").to_int())+" adventures coiling some wires!", "lime");
}

if(((my_level()) < 14 && !available_choices["skipleveling"]) || available_choices["powerlevel"]){
  powerlevel();
  set_property("post_time_powerlevel", now_to_int());
  set_property("post_advs_powerlevel", turns_played());
  print("We took "+((get_property("post_time_powerlevel").to_int() - get_property("post_time_wire").to_int())/1000)+" seconds and "+(get_property("post_advs_powerlevel").to_int() - get_property("post_advs_wire").to_int())+" adventure(s) powerleveling.", "lime");
}

// This isn't very pretty, but it works lol
if(get_property("lcs_test_order_override") == ""){

  if (!contains_text(get_property("csServicesPerformed"), "Build Playground Mazes")){ 
    test("mys");
  } 
  if (!contains_text(get_property("csServicesPerformed"), "Feed Conspirators")){
    test("mox");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Feed The Children")){
    test("mus");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Donate Blood")){
    test("hp");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Make Margaritas")){
    test("item");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Clean Steam Tunnels")){
    test("hot_res");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Breed More Collies")){
    test("fam_weight");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Be a Living Statue")){
    test("non_combat");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Reduce Gazelle Population")){
    test("weapon_damage");
  }
  if (!contains_text(get_property("csServicesPerformed"), "Make Sausage")){
    test("spell_damage");
  }
  
} else {
string [int] indv_tests = split_string(get_property("lcs_test_order_override"), "\\, ");

for i from 0 to (count(indv_tests) - 1) {
switch(indv_tests[i]){
  default:
    abort(`Test {indv_tests[i]} is an invalid test!`);

  case "mys":
    if (!contains_text(get_property("csServicesPerformed"), "Build Playground Mazes")){ 
      test("mys");
    }
    break;

  case "mox":
    if (!contains_text(get_property("csServicesPerformed"), "Feed Conspirators")){
      test("mox");
    }
    break;

  case "mus":
    if (!contains_text(get_property("csServicesPerformed"), "Feed The Children")){
      test("mus");
    }
    break;

  case "hp":
    if (!contains_text(get_property("csServicesPerformed"), "Donate Blood")){
      test("hp");
    }
    break;

  case "hot res":
    if (!contains_text(get_property("csServicesPerformed"), "Clean Steam Tunnels")){
      test("hot_res");
    }
    break;

  case "non combat":
    if (!contains_text(get_property("csServicesPerformed"), "Be a Living Statue")){
      test("non_combat");
    }
    break;

  case "item":
    if (!contains_text(get_property("csServicesPerformed"), "Make Margaritas")){
      test("item");
    }
    break;

  case "fam weight":
    if (!contains_text(get_property("csServicesPerformed"), "Breed More Collies")){
      test("fam_weight");
    }
    break;

  case "weapon damage":
    if (!contains_text(get_property("csServicesPerformed"), "Reduce Gazelle Population")){
      test("weapon_damage");
    }
    break;

  case "spell damage":
    if (!contains_text(get_property("csServicesPerformed"), "Make Sausage")){
      test("spell_damage");
    }
  }
}
}

cli_execute(`/whitelist {clan_at_start}`);

if(get_property("csServicesPerformed").split_string(",").count() == 11){
  donate_body_to_science();
}


print("Done!", "green");

print(`Time taken: {((now_to_int() - get_property("lcs_time_at_start").to_int())/60000)} minute{is_plural((now_to_int() - get_property("lcs_time_at_start").to_int())/60000)} and {(floor((now_to_int() - get_property("lcs_time_at_start").to_int())%60000/1000.0))} second{is_plural(floor((now_to_int() - get_property("lcs_time_at_start").to_int())%60000/1000.0))}.`, "teal");
print("Turns used: "+turns_played()+" turns.", "teal");
newline();

print("Pulls used:", "green");
foreach it, x in split_string(get_property("_roninStoragePulls"),","){
	print(x.to_item(), "teal");
}
newline();
print(`Organ use: {my_fullness()} fullness, {my_inebriety()} drunkeness{available_amount($item[Designer Sweatpants]).to_boolean() ?  " (" + get_property("_sweatOutSomeBoozeUsed").to_string() + "/3 sweat out some booze used)" : ""}, {my_spleen_use()} spleen`, "lime");
newline();
print("Summary:", "green");
summary(false);
}

