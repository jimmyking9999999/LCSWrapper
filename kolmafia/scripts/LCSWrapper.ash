script "lcswrapper.ash";
import <LCSWrapperResources.ash>
import <LCSWrapperMenu.ash>

// LCSWrapper - The entire run, drawn upon resources in the LCSWrapperResources script. The preference manager/summary are located in LCSWrapperMenu. Combat is mostly in this script, but is slowly being shifted to LCSWrapperCombat.

print_html("<center><font color=66b2b2><font size=3><i>Running LCSWrapper!</i></font></font></center>");

boolean sekrit;
item mainstat_pizza = my_primestat() == $stat[Mysticality] ? $item[Calzone of Legend] : my_primestat() == $stat[Muscle] ? $item[Deep Dish of Legend] : $item[Pizza of Legend];
string COMBAT_freefight = "if hasskill chest x-ray; skill chest x-ray; endif; if hasskill shattering punch; skill shattering punch; endif; if hasskill gingerbread mob hit; skill gingerbread mob hit; endif; if hasskill shocking lick; skill shocking lick; endif; if hascombatitem groveling gravel; use groveling gravel; endif; abort";

void ascend() {
  // Ascends pastamancer, path blender. Buys astral pilsners & a pet sweater 
  visit_url("afterlife.php?action=pearlygates");
  visit_url( "afterlife.php?action=buydeli&whichitem=5040" );

  print("Stepping into the Mortal Realm in 25 seconds without any perms! Press ESC to manually perm skills!", "teal");
  waitq(20); 
  wait(5);

  visit_url("afterlife.php?action=ascend&confirmascend=1&whichsign=8&gender=2&whichclass=3&whichpath=25&asctype=2&nopetok=1&noskillsok=1&pwd", true);
  visit_url("choice.php");
  run_choice(1);
  refresh(); 
}



// Toot oriole/Start-of-day-actions
void oriole() {

print(item_amount($item[Bird-a-Day calendar]).to_boolean() ? "Visiting your second favourite bird..." : "Visiting your favourite bird...", "teal");

if(get_property("questM05Toot") != "finished"){
  visit_url('tutorial.php?action=toot');
  
  use(1, $item[letter from king ralph xi]);
  use(1, $item[pork elf goodies sack]);

  // Mayday owners / trainset owners save a baconstone and hamethyst for desert potions later on
  if((get_property("hasMaydayContract").to_boolean() && my_class() == $class[Sauceror]) || item_amount($item[model train set]).to_boolean() || get_property("lcs_deck_usage").contains_text("Mantle")){
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

if(!have_skill($skill[Seek out a Bird]) && item_amount($item[Bird-a-Day calendar]).to_boolean()){
  print("Visiting your favourite bird now!", "teal");
  use(1, $item[Bird-a-Day calendar]);
}

if(get_property("lcs_deck_usage").contains_text("Mantle") && available_amount($item[Deck of Every Card]).to_boolean() && get_property("_deckCardsDrawn") == "0"){
  cli_execute("cheat 1952 Mickey Mantle");
  autosell(1, $item[1952 Mickey Mantle card]);
}

print("Now setting up beginning-of-ascension stuff...", "teal");

if(get_property("lcs_autopull_at_start") != "" && pulls_remaining() == 5){

  print("Now pulling some items automatically for you!", "teal");
  newline();

  foreach x, it in split_string(get_property("lcs_autopull_at_start"), "\\,"){
    if(it.to_item() == $item[none]){
      print(`Warning: {it} isn't a valid item, according to KoLMafia! Skipping...`, "red");
      waitq(5);
    } else {
      string ite = it.to_item().to_string();

      print(`Pulling 1 {ite}!`, "teal");
      refresh();
      take_storage(1, it.to_item());
      // why does this not work >=(
    }
  }

}


if(!available_amount($item[Toy accordion]).to_boolean()){
  retrieve_item(1, $item[Toy accordion]);
}

if(available_amount($item[Songboom&trade; Boombox]) > 0 && get_property("boomBoxSong") != "Total Eclipse of Your Meat"){
	cli_execute("Boombox meat");
}

if(get_property("_saberMod") == "0" && available_amount($item[Fourth of May Cosplay Saber]).to_boolean()) {
	visit_url("main.php?action=may4");
	run_choice(4);
}

if(available_amount($item[S.I.T. Course Completion Certificate]).to_boolean() && !get_property("_sitCourseCompleted").to_boolean()){
  string prev_SIT = get_property("choiceAdventure1494");
  set_property("choiceAdventure1494", "1");
  use(1, $item[S.I.T. Course Completion Certificate]);
  set_property("choiceAdventure1494", prev_SIT);
}

maximize(`0.2 mp, 0.2 hp, 0.1 item, 3 familiar weight, 5 {my_primestat()} exp, 10 {my_primestat()} experience percent, 0.5 {my_primestat()} percent, 0.1 {my_primestat()}, 0.001 DA, 69 bonus tiny stillsuit, 80 bonus dromedary drinking helmet, 3000 bonus designer sweatpants, 1000 bonus latte lovers member's mug, 200 bonus jurassic parka, 200 bonus june cleaver, -equip broken champagne bottle, -equip Kramco Sausage-o-Matic -equip makeshift garbage shirt -equip i voted -tie`, false);

// Autumn leaf for 25% item
if(item_amount($item[autumn-aton]).to_boolean()){
  cli_execute("try; Autumnaton send sleazy back alley");
}

use_current_best_fam();

if(get_property("chateauAvailable").to_boolean() && !get_property("_chateauDeskHarvested").to_boolean()){
  visit_url("place.php?whichplace=chateau&action=chateau_desk");
}

if(!available_amount($item[your cowboy boots]).to_boolean() && get_property("telegraphOfficeAvailable").to_boolean()){
  visit_url("place.php?whichplace=town_right&action=townright_ltt");
}

if(get_property("hasDetectiveSchool").to_boolean() && !(available_amount($item[plastic detective badge]).to_boolean() && available_amount($item[bronze detective badge]).to_boolean() && available_amount($item[silver detective badge]).to_boolean() && available_amount($item[gold detective badge]).to_boolean())){
  visit_url("place.php?whichplace=town_wrong&action=townwrong_precinct");
}



if(familiar_equipped_equipment(my_familiar()) != $item[Tiny Stillsuit] && familiar_equipped_equipment(my_familiar()) != $item[dromedary drinking helmet] &&available_amount($item[Tiny Stillsuit]).to_boolean()){
  equip($slot[Familiar], $item[Tiny Stillsuit]);
}

if(item_amount($item[mumming trunk]) > 0) {
	cli_execute(`try; mummery {my_primestat()}`);
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
    // all stat -> coal -> {mainstat} -> meat -> mp -> ore -> ml -> hotres
    // [  WE ONLY HIT THESE  ]   [       THESE DO NOT MATTER      ]

    switch (my_primestat()) {
      case $stat[Muscle]:
        visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=3&slot[1]=8&slot[2]=17&slot[3]=1&slot[4]=2&slot[5]=20&slot[6]=19&slot[7]=4",true,true);
      break;

      case $stat[Mysticality]:
        visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=3&slot[1]=8&slot[2]=16&slot[3]=1&slot[4]=2&slot[5]=20&slot[6]=19&slot[7]=4",true,true);
      break;

      case $stat[Moxie]:
        visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=3&slot[1]=8&slot[2]=14&slot[3]=1&slot[4]=2&slot[5]=20&slot[6]=19&slot[7]=4",true,true);
      break;    
    }

    refresh();
  }
}

if(!available_amount($item[Ebony Epee]).to_boolean() && item_amount($item[Spinmaster&trade; lathe]).to_boolean()) {
	visit_url("shop.php?whichshop=lathe");
	retrieve_item(1, $item[Ebony Epee]);
}

set_auto_attack(0);

cli_execute("try; backupcamera reverser on");

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

if(item_amount($item[Napalm In The Morning&trade; candle]).to_boolean()){
  use(1, $item[Napalm In The Morning&trade; candle]);
}

if(!have_effect($effect[Inscrutable Gaze]).to_boolean() && have_skill($skill[Inscrutable Gaze])){
  use_skill(1, to_skill($effect[Inscrutable Gaze]));
}

if ((get_property("voteAlways").to_boolean()) && !(get_property("_voteToday").to_boolean())){
  visit_url('place.php?whichplace=town_right&action=townright_vote');
  waitq(1);
  switch (my_class()){
    case $class[Sauceror]:
      visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=1&local[]=1',true,false);
    break;

    case $class[Pastamancer]:
      visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=2&local[]=2',true,false);
    break;

    case $class[Seal Clubber]:
      visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=1&local[]=2',true,false);
    break;

    case $class[Turtle Tamer]:
      visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=0&local[]=0',true,false);
    break;

    case $class[Accordion Thief]:
      visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=2&local[]=2',true,false);
    break;

    case $class[Disco Bandit]:
      visit_url('choice.php?pwd&option=1&whichchoice=1331&g='+(random(2) + 1)+'&local[]=0&local[]=0',true,false);
    break;
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
      chatbot = "onlyfax";
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

set_auto_attack("none");


if(available_amount($item[Cherry]) == 0){
  print("Adventuring/mapping for a novelty tropical skeleton!", "teal");
  cli_execute("parka dilophosaur");

  string cs_wrapper_freerun = `if monstername novelty tropical skeleton || monsterid 1746; skill spit jurassic acid; abort; endif; {freerun};`;

  if(have_familiar($familiar[Pair of Stomping Boots]) && !have_skill($skill[Map the Monsters])){
    cs_wrapper_freerun = "if monstername novelty tropical skeleton || monsterid 1746; skill spit jurassic acid; abort; endif; runaway";
    use_familiar($familiar[Pair of Stomping Boots]);
    
    if(!have_familiar($familiar[Shorter-Order Cook])){
      use_skill($skill[Leash of Linguini]);
      // The reason for the cli_execute is since it automatically fishes for a turtle totem
      cli_execute(have_skill($skill[Blood Bond]) ? "up blood bond" : "try; up empathy");
    }
  }

  if(have_skill($skill[Map the Monsters])){

    if(!contains_text(get_property("lastEncounter"), "Skeletons In Store")){
      adv1($location[The Skeleton Store], -1, "abort");
    }

    use_skill($skill[Map the Monsters]);

    visit_url("adventure.php?snarfblat=439");
    if (handling_choice() && last_choice() == 1435){
      run_choice(1, false, `heyscriptswhatsupwinkwink={$monster[Novelty Tropical Skeleton].to_int()}`);

      run_combat("skill spit jurassic acid; abort");
    } else { abort("We couldn't map properly...?"); }

  } 
    
  while(item_amount($item[Cherry]) == 0){

    // Snokebomb
    if(my_mp() < 30 && !have_skill($skill[Feel Hatred]).to_boolean()){
      buy(2, $item[Doc Galaktik's Invigorating Tonic]);
      use(2, $item[Doc Galaktik's Invigorating Tonic]);
    }

    adv1($location[The Skeleton Store], -1, cs_wrapper_freerun);

    if(((get_property("_banderRunaways").to_int() + 1) * 5) >= numeric_modifier("Familiar Weight") && have_familiar($familiar[Pair of Stomping Boots])){
      abort("Either we're somewhat unlucky or something went really wrong");
    } 

  }
  

  print("Stat equalizer obtained!", "teal");
  newline();

  if(!item_amount($item[Cherry]).to_boolean()){
    abort("We don't have a cherry? Uh oh.");
  }

}

if(get_property("_juneCleaverFightsLeft") == 0 && have_equipped($item[June Cleaver])){
  adv1($location[Noob Cave]); 
}

// This chunk below will attempt to skip borrowed time via level with 4 freeruns and a trainset + swap.

// [                              Have familiars or skip time pref                                                                                     ] + [             Not in hardcore or train already set               ]
if( (have_familiar($familiar[Pair of Stomping Boots]) || get_property("lcs_skip_borrowed_time") == "Yes" || have_familiar($familiar[Frumious Bandersnatch]))  && !in_hardcore() && get_property("trainsetConfiguration") != ""){
    string shadow_freerun = "if hasskill feel hatred; skill feel hatred; endif; if hasskill reflex hammer; skill reflex hammer; endif; if hasskill snokebomb; skill snokebomb; endif; if hasskill Throw Latte on Opponent; skill Throw Latte on Opponent; endif; abort;";
    
    if(have_familiar($familiar[Pair of Stomping Boots])){
      get_effect($effect[Leash Of Linguini]);
      use_familiar($familiar[Pair of Stomping Boots]);
      shadow_freerun = "runaway; repeat !times 5; abort";

    } else if (have_familiar($familiar[Frumious Bandersnatch])){

      if(my_maxmp() < 50){
        maximize("mp 50 min 50 max, -tie", false);
      } 

      if(my_mp() < 50){
        restore_mp(50);
      }

      get_effect($effect[Ode to Booze]);
      get_effect($effect[Leash Of Linguini]);
      use_familiar($familiar[Frumious Bandersnatch]);
      shadow_freerun = "runaway; repeat !times 5; abort";
    }
    
    
    if(get_property("trainsetPosition").to_int() > 3 && my_level() < 3){
      abort(`Trainset went over {my_primestat()}, yet we're lower then level 3...`);
    }

    while(get_property("trainsetPosition").to_int() < 3){
      adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, shadow_freerun);
    }


    if(40 + get_property("lastTrainsetConfiguration").to_int() - get_property("trainsetPosition").to_int() >= 0){
      print(`Resetting train position to hit Coal -> {my_primestat()} again!`, "teal");
      visit_url("campground.php?action=workshed");

      switch (my_primestat()) {
        case $stat[Muscle]: //17
          visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=14&slot[1]=4&slot[2]=7&slot[3]=8&slot[4]=17&slot[5]=1&slot[6]=3&slot[7]=16",true,true);
        break;

        case $stat[Mysticality]: //16
          visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=14&slot[1]=4&slot[2]=7&slot[3]=8&slot[4]=16&slot[5]=1&slot[6]=3&slot[7]=17",true,true);
        break;

        case $stat[Moxie]:  //14
          visit_url("choice.php?pwd&whichchoice=1485&option=1&slot[0]=16&slot[1]=4&slot[2]=7&slot[3]=8&slot[4]=14&slot[5]=1&slot[6]=3&slot[7]=17",true,true);
        break;

      }

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

    
    // TODO: Borrowed time skip with a perfect drink? 

  if(storage_amount(mainstat_pizza).to_boolean()){
    take_storage(1, mainstat_pizza);
  }
      

  if(item_amount(mainstat_pizza) == 0){
    print("We don't have a t3 CBB food... Let's use a borrowed time instead.", "red");
    waitq(5);

    if(!get_property("_borrowedTimeUsed").to_boolean() && !clip_art($item[Borrowed Time])){
      pull_item($item[Borrowed Time]);
    }

    if(item_amount($item[Borrowed Time]).to_boolean()){
      use(1, $item[Borrowed Time]);
    }
  }

} else if(my_level() < 5 || ((item_amount(mainstat_pizza) == 0) && !in_hardcore())){

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

    adv1($location[The Sleazy Back Alley], -1, "abort");

    get_effect($effect[Ode to Booze]);
    drink(3, $item[Distilled fortified wine]);
  }
}


print("Setting up bowling ball + spikes in your scaler zone!", "teal");

cli_execute("parka spikolodon");

if(!available_amount($item[red rocket]).to_boolean() && !have_effect($effect[Everything Looks Red]).to_boolean()){
  buy(1, $item[Red Rocket]);
}

// TODO: Swap nep w/scaler zone lol.

if(scaler_zone == $location[The Neverending Party]){
  if(get_property("_questPartyFair") == "unstarted"){
    visit_url("adventure.php?snarfblat=528");

    switch(get_property("_questPartyFairQuest")) {
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
}


if(available_amount($item[Kramco Sausage-o-Matic&trade;]).to_boolean() && !get_property("_spikolodonSpikeUses").to_boolean()){
  equip($item[Kramco Sausage-o-Matic&trade;]);

  use_current_best_fam();

  if(my_hp() < my_maxhp()){
    cli_execute("hottub");
  }

  string cswrappersideways = "if hasskill bowl sideways; skill bowl sideways; endif; if hascombatitem red rocket; use red rocket; endif; if hasskill Launch spikolodon spikes; skill Launch spikolodon spikes; endif; attack;";
  adv1($location[The Neverending Party], -1, cswrappersideways);
}



if(my_level() >= 5){
  eat(1, mainstat_pizza);
}


if(my_adventures() == 60){
  print("Let's get you a few more adventures to coil the wire!", "teal");
}


// TODO: this
while(my_adventures() == 60){
  if(have_skill($skill[Calculate the Universe])){
    cli_execute("try; numberology 69");
    break;
  }


}


maximize("MP, 0.1 mys percent, 10 MP Regen", false);

// TODO: Blue Rocket for the above? ^

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


if(get_property("lcs_deck_usage").contains_text("Green") && available_amount($item[Deck of Every Card]).to_boolean() && !available_amount($item[Green Mana]).to_boolean() && !have_effect($effect[Giant Growth]).to_boolean()){
  if(!have_skill($skill[Giant Growth])){
    print("We don't have giant growth? Huh?", "red");
    waitq(5);
  } else {
    cli_execute("cheat Forest");
  }
}

if(have_equipped($item[Kramco Sausage-o-Matic&trade;])){
  equip($slot[Off-hand], $item[none]);
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
        print("Happy Halloween! This script won't Trick-or-Treat for you, unfortunately. Maybe next time, hehe.", "orange");

      case "Dependence Day":
        print("Happy Dependence Day! Let's buy a sparkler to celebrate!", "teal");
        switch(my_primestat()){
          case $stat[Mysticality]:
            buy(1, $item[Sparkler]); use(1, $item[Sparkler]);
          break;

          case $stat[Moxie]:
            buy(1, $item[Snake]); use(1, $item[Snake]);
          break;

          case $stat[Muscle]:
            buy(1, $item[M-242]); use(1, $item[M-242]);
          break;

        }

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

  visit_url("adventure.php?snarfblat=528");
  if(current_round() == 1){
    run_combat(freerun);
  }
  run_choice(1); run_choice(2);
}

if(get_property("lcs_august_scepter") == "Offhand Remarkable Before Powerleveling"){
  august_scepter(13);
}

if(get_property("tomeSummons") == "0" && !have_effect($effect[Purity of Spirit]).to_boolean() && get_property("lcs_skip_filtered_water") != "Yes"){
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

if(get_property("lcs_seventy").to_boolean()){
  wish_effect("Witch Breaded");
}


if(available_amount($item[Eight Days a Week Pill Keeper]).to_boolean() && have_familiar($familiar[Comma Chameleon]) && !have_effect($effect[Hulkien]).to_boolean()){
  cli_execute("pillkeeper stat");
}

if(!have_effect($effect[A Contender]).to_boolean() && get_property("lcs_get_a_contender") == "Yes"){
  wish_effect("A contender");
}

effect mainstat_experience_effect = my_primestat() == $stat[Mysticality] ? $effect[Different Way Of Seeing Things] : my_primestat() == $stat[Moxie] ? $effect[Thou Shant Not Sing] : $effect[HGH-charged];
if(get_property("lcs_wish_mainstat_percent") == "Yes" && !have_effect(mainstat_experience_effect).to_boolean()){
  wish_effect(mainstat_experience_effect);
}

if(!get_property('_clanFortuneBuffUsed').to_boolean() && get_property("lcs_vip_fortune_buff") != "None"){
  cli_execute(`fortune buff {get_property("lcs_vip_fortune_buff").to_lower_case()}`);
}

if(available_amount($item[pebble of proud pyrite]).to_boolean()){
  use(1, $item[pebble of proud pyrite]);
}

if (!get_property('_floundryItemCreated').to_boolean()){
  cli_execute(`try; acquire {get_property("lcs_floundry").to_lower_case() != "none" ? get_property("lcs_floundry") : ""}`); 

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
  maximize(`0.1 mp, 100 {my_primestat()} experience percent`, false);
}

if((!get_property("telescopeLookedHigh").to_boolean()) && (get_property("telescopeUpgrades") != "0")){
  cli_execute("up starry");
} //inb4 another effect beginning with 'starry' is introduced to the game and this breaks

if(!get_property("lyleFavored").to_boolean()){
  cli_execute("up lyle");
}

if(!get_property("_aprilShower").to_boolean()){
  cli_execute(my_primestat() == $stat[Mysticality] ? "shower lukewarm" : my_primestat() == $stat[Moxie] ? "shower cool" : "shower hot");
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

string mainstat_pizza_eaten = (mainstat_pizza == $item[Deep Dish of Legend]) ? "deepDishOfLegendEaten" : (mainstat_pizza == $item[Calzone Of Legend]) ? "calzoneOfLegendEaten" : "pizzaOfLegendEaten";

if(storage_amount(mainstat_pizza).to_int() == 0 && !get_property(mainstat_pizza_eaten).to_boolean() && !in_hardcore()){
  print(`You don't have a {mainstat_pizza} in your Hagnk's. That's... not good.`, "red");
  print("We're going to attempt to continue, after 10 seconds. This may fail for a variety of reasons.", "red");
  waitq(10);

  print("Pulling an pressurized potion instead...", "red");
  switch(my_primestat()){
    case $stat[Mysticality]:
      pull_item($item[pressurized potion of perspicacity]);
      use(1, $item[pressurized potion of perspicacity]);
    break;
    case $stat[Muscle]:
      pull_item($item[pressurized potion of puissance]);
      use(1, $item[pressurized potion of puissance]);
    break;
    case $stat[Moxie]:
      pull_item($item[pressurized potion of pulchritude]);
      use(1, $item[pressurized potion of pulchritude]);
    break;
  }

} else if(!get_property(mainstat_pizza_eaten).to_boolean() && !in_hardcore()){

  if(have_effect($effect[Ready to eat]) == 0){
    print("Huh? We don't have ready to eat?", "red");
    print("That's weird, but we'll continue.", "red");
    waitq(5);
  }

  print(`Pulling an {mainstat_pizza}...`, "teal");
  take_storage(1, mainstat_pizza);
  eat(1, mainstat_pizza);
}



print(`Restoring MP and buffing up {my_primestat()}!`,"teal");


if(available_amount($item[Magical sausage casing]) > 0 && get_property("_sausagesEaten") == 0 && available_amount($item[Kramco Sausage-o-Matic&trade;]).to_boolean()){
  cli_execute("eat 1 magical sausage");
}

if((have_effect($effect[Tomes of Opportunity]) == 0) && get_property("noncombatForcerActive").to_boolean()){
  visit_url("adventure.php?snarfblat=528");
  run_choice(1); run_choice(2);
}

if(item_amount($item[Powerful Glove]).to_boolean()){
  equip($slot[acc3], $item[Powerful Glove]);
}

if(available_amount($item[beach comb]).to_boolean()) {
	get_effect($effect[You learned something maybe!]);

  switch (my_primestat()) {
    case $stat[Muscle]:
      get_effect($effect[Lack of Body-Building]);
    break;

    case $stat[Mysticality]:
    	get_effect($effect[Do I know you from somewhere?]);
    break;

    case $stat[Moxie]:
      get_effect($effect[Pomp & Circumsands]);
    break;
  }

}

visit_url("clan_viplounge.php?action=lookingglass&whichfloor=2");

if(get_property("_lcs_breakfast_complete") != "true"){
foreach it in $skills[Advanced Cocktailcrafting, Advanced Saucecrafting, Pastamastery, Perfect Freeze, Prevent Scurvy and Sobriety, Grab a Cold One, Summon Kokomo Resort Pass]{
  if(have_skill(it)){ 
    use_skill(it);
  }
}

foreach x, eff in powerlevel_effects {  
  get_effect(eff.to_effect());  
}

string[int] stat_powerlevel_effects;

switch (my_primestat()) {
  case $stat[Muscle]:
    stat_powerlevel_effects = powerlevel_mus_effects;
  break;

  case $stat[Mysticality]:
    stat_powerlevel_effects = powerlevel_mys_effects;
  break;

  case $stat[Moxie]:
    stat_powerlevel_effects = powerlevel_mox_effects;
  break;
}

foreach x, eff in stat_powerlevel_effects {
  get_effect(eff.to_effect()); 
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
  if ($effect[Tainted Love Potion].numeric_modifier(my_primestat()) > 5 && $effect[Tainted Love Potion].numeric_modifier('muscle') + $effect[Tainted Love Potion].numeric_modifier('moxie') + $effect[Tainted Love Potion].numeric_modifier('mysticality') > 40){
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
// TODO Canadia signs MCD11

if(my_sign() == "Blender" && !have_effect($effect[Baconstoned]).to_boolean() && (!item_amount($item[Bitchin' Meatcar]).to_boolean() || !item_amount($item[Desert Bus Pass]).to_boolean())){
  
  if(item_amount($item[vial of baconstone juice]).to_boolean() && item_amount($item[Baconstone]).to_boolean()){
    use(1, $item[vial of baconstone juice]); 
  }
}

if(have_familiar($familiar[Melodramedary]) && have_skill($skill[Summon Clip Art]) && !available_amount($item[dromedary drinking helmet]).to_boolean() && get_property("lcs_make_camel_equip") == "Yes"){
  clip_art($item[Box of Familiar Jacks]);
  use_familiar($familiar[Melodramedary]);
  use(1, $item[Box of Familiar Jacks]);
}


maximize(`{my_primestat()}, 4 ML, 3 {my_primestat()} exp, 1.33 exp, 30 {my_primestat()} experience percent, 3 familiar exp, 160 bonus candy cane sword cane, 8000 bonus designer sweatpants, 690 bonus tiny stillsuit, 90 bonus unbreakable umbrella, -equip i voted, -equip Kramco Sausage-o-Matic, -equip makeshift garbage shirt, 100 bonus Cincho de Mayo`, false); 

if(my_hp() < my_maxhp()){
  cli_execute("hottub");
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
    print("Mapping for a goblin flapper!", "teal");

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
    adv1($location[The X-32-F Combat Training Snowman], -1, "if hasskill micrometeorite; skill micrometeorite; endif; if hasskill Surprisingly Sweet Slash; skill Surprisingly Sweet Slash; endif; if hasskill curse of weaksauce; skill curse of weaksauce; endif; if hasskill sing along; skill sing along; endif; if hasskill Surprisingly Sweet Stab; skill Surprisingly Sweet Stab; endif; skill saucegeyser; skill saucegeyser; attack;");
  }
}

// TODO: Use june cleaver and have it autoadv in noob cave when ready
if((!have_effect($effect[Shadow Waters]).to_boolean() && (item_amount($item[closed-circuit pay phone]).to_boolean()))){
  string shadow_rift_combat = "if !haseffect 2698; if hasskill 7407 && !haseffect 2698; skill 7407; endif; endif; if hasskill 7297; skill 7297; endif; if hasskill curse of weaksauce; skill curse of weaksauce; endif; call sa; repeat !times 6; attack; repeat !times 10; sub sa; if !mpbelow 30; skill saucegeyser; endif; endsub; abort";

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

  /* Lodestone */
  if(get_property("_shadowRiftCombats") == "11"){
    adv1($location[Shadow Rift (The Right Side of the Tracks)], -1, shadow_rift_combat);
  }
}


if(get_property("lcs_rem_witchess_witch") == "Yes (Before Powerleveling)" && !available_amount($item[battle broom]).to_boolean()){
  print("Recalling that one time when you were reincarnated as a witchess witch.","teal");

  if(my_hp() * 1.3 > my_maxhp()){
    cli_execute("hottub");
  }
  
  if(have_skill($skill[Feel Nervous])){ 
    use_skill($skill[Feel Nervous]);
  }

  maximize("100 weapon damage, mys, -1 moxie, -1 muscle, -10 ml, 1000 bonus fourth of may cosplay saber, -equip combat lover's locket", false);
  refresh();

  string combat_filter = "sub LTS; if hasskill Lunging Thrust-Smack; skill Lunging Thrust-Smack; endif; endsub; call LTS; repeat !times 20; attack; repeat !times 9";
  if(!witchess_fight($monster[Witchess Witch], combat_filter)){
    visit_url("inventory.php?reminisce=1", false);
    visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1941");

    run_combat(combat_filter);
  } 

  maximize(`{my_primestat()}, 4 ML, 3 {my_primestat()} exp, 1.33 exp, 30 {my_primestat()} experience percent, 3 familiar exp, 8000 bonus designer sweatpants, 690 bonus tiny stillsuit, 90 bonus unbreakable umbrella, -equip i voted, -equip Kramco Sausage-o-Matic, 100 bonus Cincho de Mayo`, false); 
}


use_current_best_fam();

love_tunnel();
maximize(`100 {my_primestat()} experience percent, -tie`, false);

if(available_amount($item[January's Garbage Tote]).to_boolean()){
  cli_execute("fold makeshift garbage shirt");
  equip($item[Makeshift Garbage Shirt]);
}

// ghost yoked
if(have_familiar($familiar[Ghost of Crimbo Carols]) && !have_effect($effect[Holiday Yoked]).to_boolean() && !get_property("lcs_skip_yoked").to_boolean()){
  use_familiar($familiar[Ghost of Crimbo Carols]);
}

if(available_amount($item[Autumn-aton]).to_boolean()){
  cli_execute("try; autumnaton send The Neverending Party");
}

boolean yoked_obtained = false;
string nep_powerlevel = "if hasskill Micrometeorite; skill Micrometeorite; endif; if hasskill Surprisingly Sweet Slash; skill Surprisingly Sweet Slash; endif; if hasskill 7486; skill 7486; endif; if hascombatitem green mana && hasskill giant growth; skill giant growth; endif; if hasskill feel pride; skill feel pride; endif; if hasskill curse of weaksauce; skill curse of weaksauce; endif; if hasskill sing along; skill sing along; endif; if hasskill 7444; if hasskill Stuffed Mortar Shell; if hasskill Surprisingly Sweet Stab; skill Surprisingly Sweet Stab; endif; if hasskill shadow noodles; skill shadow noodles; endif; skill Stuffed Mortar Shell; skill 7444; endif; endif; skill saucegeyser; skill saucegeyser; attack; repeat !times 10; abort;";
string nep_freerun_sideways = `skill bowl sideways; {freerun}; {nep_powerlevel}`;
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
    string [int] cleaverQueue = get_property("juneCleaverQueue").split_string(","); 

    if(cleaverQueue[cleaverQueue.count() - 1] == "1467" || cleaverQueue[cleaverQueue.count() - 1] == "1471"){ 
      use_skill($skill[Tongue of the Walrus]);
    } else {
      abort("We got beaten up =(");
    }
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

int freekills = get_all_freekills() >= 1 ? get_all_freekills() - 1 : get_all_freekills();
// Saves two freekills for Fax/Lockets when running a 1/70 attempt
if(get_property("lcs_seventy") == "true"){
  freekills = freekills >= 2 ? freekills - 2 : freekills;
}

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

print("Fighting a sausage goblin from the Kramco!","teal");
if(available_amount($item[Kramco Sausage-o-Matic&trade;]).to_boolean()){
  equip($item[Kramco Sausage-o-Matic&trade;]);

  if(!contains_text(get_property("lastEncounter"), "sausage goblin")){
    if(my_hp() < my_maxhp()){
      cli_execute("hottub");
    }


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
} else if(available_amount($item[Backup Camera]).to_boolean()) {
  // Locket or fax a kramco
  visit_url("inventory.php?reminisce=1", false);
  visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=2104");

  run_combat("skill saucegeyser; repeat !times 4; abort;");
}



use_current_best_fam();
int backup_uses = get_property(`lcs_alloted_backup_uses`).to_int();

if(backup_uses != 0 && available_amount($item[Backup Camera]).to_boolean()){
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

// TODO Witchess + Burning Leaves

if(get_property("_shortOrderCookCharge").to_int() >= 9 || (get_property("camelSpit").to_int() > 94 && get_property("camelSpit").to_int() < 100)){
  foreach num in $strings[8, 22]{
    if(!get_property(`_aug{num}Cast`).to_boolean()){
	    visit_url(`runskillz.php?action=Skillz&whichskill={7451 + num.to_int()}&targetplayer=${my_id()}&pwd=&quantity=1`);
      run_combat("skill saucegeyser; repeat !times 2; attack; repeat !times 3;");
    }
  }
}

}

void mys_test(){
  equalize_stats();

  maximize("mys, switch left-hand man", false); 

  cs_test(3);
}


void mox_test(){ 
  equalize_stats();

  maximize("mox, switch left-hand man", false); 

  cs_test(4);
}

void mus_test(){
  equalize_stats();

  maximize("mus, switch left-hand man", false); 

  cs_test(2);
}

void hp_test(){
  equalize_stats();
  maximize("hp, switch left-hand man", false); 

  cs_test(1);
}



void item_test(){

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
  adv1($location[The Limerick Dungeon],  -1, "abort");
  refresh();
  use(1, $item[Cyclops eyedrops]);
}


// TODO: Check map uses. Maybe check xrays?

if(have_familiar($familiar[Trick-or-Treating Tot]) && have_skill($skill[Map the Monsters]) && !available_amount($item[li'l ninja costume]).to_boolean() && get_all_freekills() > 0){
  print("Now mapping for the ninja outfit!", "teal");
  use_skill($skill[Map the Monsters]);


  visit_url("adventure.php?snarfblat=138");
    if (handling_choice() && last_choice() == 1435){
      run_choice(1, false, `heyscriptswhatsupwinkwink={$monster[Amateur ninja].to_int()}`);
      run_combat(COMBAT_freefight);
      
    } else { abort("We couldn't map properly...?"); }

}




if(get_property("sourceTerminalEducateKnown") != ""){
  cli_execute("try; terminal enhance items.enh");
}

maximize(`item, booze drop, -equip broken champagne bottle, {(have_familiar($familiar[Trick-or-Treating Tot]) && available_amount($item[li'l ninja costume]).to_boolean()) ? "switch Trick-or-Treating Tot" : "switch left-hand man"}`, false); 

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


if(get_property("lcs_deck_usage").contains_text("Rope") && available_amount($item[Deck of Every Card]).to_boolean() && !available_amount($item[Rope]).to_boolean()){
  cli_execute("cheat rope");
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


if(get_property("lcs_seventy").to_boolean() && get_property("_locketMonstersFought").split_string(",").count() < 2){
  visit_url("inventory.php?reminisce=1", false);
  visit_url(`choice.php?whichchoice=1463&pwd&option=1&mid={$monster[Cocktail Shrimp].id}`);

  refresh();
  run_combat(freerun);

  visit_url("inventory.php?reminisce=1", false);
  visit_url(`choice.php?whichchoice=1463&pwd&option=1&mid={$monster[Toothless Mastiff Bitch].id}`);
  
  refresh();
  run_combat("skill feel nostalgic; skill feel envy; skill gingerbread mob hit");

  if(11 > get_property("_shortOrderCookCharge").to_int() && get_property("_shortOrderCookCharge").to_int() > 6){
    use_familiar($familiar[Shorter-Order Cook]);
    for i from 1 to 11 - get_property("_shortOrderCookCharge").to_int(){
      print(i);
    }
  }
}




if(get_property("lcs_seventy") == "true" && !get_property("_photocopyUsed").to_boolean() && available_amount($item[photocopied monster]) == 0){
  print("Now faxing a Pterodactyl!", "teal");

  if(is_online("OnlyFax")){
    chat_private("OnlyFax", "Pterodactyl");
  } else { 
    chat_private("EasyFax", "Pterodactyl");
  }


  for i from 1 to 3 {
    wait(6);
    cli_execute("fax receive");
    if (get_property("photocopyMonster") != "Pterodactyl") {
      cli_execute("fax send");
    } else {
      break;
    }
  }
    
  

  if (available_amount($item[photocopied monster]) == 0 && (get_property("photocopyMonster") != "Pterodactyl")){
    print(`Failed to fax a Pterodactyl!`, "red");
  } else {
    visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem=4873`);
    run_combat(`if hasskill feel envy; skill feel envy; endif; ` + COMBAT_freefight);
  }

  get_effect($effect[Over-Familiar With Dactyls]);
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



if(!available_amount($item[overloaded Yule battery]).to_boolean() && have_familiar($familiar[Mini-Trainbot]) && have_skill($skill[Summon Clip Art]) && !have_familiar($familiar[Comma Chameleon])){
  if(!item_amount($item[Box of Familiar Jacks]).to_boolean()){
    clip_art($item[Box of Familiar Jacks]);
  }
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
  
  string saber_foam = "if hasskill Mist Form; skill mist form; endif; skill Fire Extinguisher: Foam Yourself; skill Use the Force;";
  // TODO: Add a check if the user can clear weapon damage in <30 turns
   
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

// Don't pay attention to this ;3
if(get_property("lcs_seventy").to_boolean()){
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

maximize('-combat, 0.04 familiar weight 75 max, switch disgeist, switch left-hand man, switch disembodied hand, -tie', false);


// For list of effects, look at LCSWrapperResources.ash

cs_test(8);
}

void weapon_damage_test(){ 

if(available_amount($item[Songboom&trade; Boombox]) > 0 && get_property("boomBoxSong") != "These Fists Were Made for Punchin\'"){
	cli_execute("Boombox damage");
}

if(get_property("lcs_use_birds") == "During Weapon or Spell Damage Test"){
  if(get_property("_birdOfTheDayMods").contains_text("Weapon")){
    use_skill(1, $skill[Visit your Favorite Bird]);
  }
}

// TODO Equip KGE + Bowling ball check 
if(get_property("_snokebombUsed").to_int() <= 2){
  melf_buff();
}

camel_spit();

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
  
  if(get_property("_hotTubSoaks").to_int() < 5){
    cli_execute("hottub");
  } else if(have_skill($skill[Cannelloni Cocoon])){
    use_skill(ceil((my_maxhp() - my_hp()) / 1000), $skill[Cannelloni Cocoon]);
  }

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



if(available_amount($item[Stick-knife of Loathing]) == 0 && pulls_remaining() > 0 && storage_amount($item[Stick-knife of Loathing]).to_boolean() && (my_basestat($stat[Muscle]) >= 150 || (my_class() == $class[Pastamancer] && have_skill($skill[Bind Undead Elbow Macaroni]))) ){
  
  if(my_basestat($stat[Muscle]) >= 150){
    take_storage(1, $item[Stick-knife of Loathing]);
    equip($item[Stick-knife of Loathing]);
  }

  foreach x, outfit_name in get_custom_outfits(){

    if(outfit_pieces(outfit_name).count() == 1 && !have_equipped($item[Stick-knife of Loathing])){

      if(outfit_pieces(outfit_name)[0] == $item[Stick-knife of Loathing]){
        print(`Outfit '{outfit_name}' has a stick-knife in it! Pulling a stick-knife and trying to equip that outfit...`, "teal");

        take_storage(1, $item[Stick-knife of Loathing]);
        use_skill(1, $skill[Bind Undead Elbow Macaroni]);
        outfit(outfit_name);
        break;
      } 
    }
  }

  if(!equipped_amount($item[Stick-knife of Loathing]).to_boolean()){
    print("Uh-oh, you don't have an outfit with a knife in it! Make one after the run finishes!", "red");
    waitq(5);
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
/*foreach it in $slots[weapon, off-hand, familiar]{
  if(equipped_item(it) == $item[Stick-knife of Loathing])
  equip(it, $item[none]);
}*/

meteor_shower();

refresh();

matcher weapon_damage_matcher = create_matcher("<br>Weapon Damage \\+(\\d+)<br>", visit_url(`desc_item.php?whichitem=113452664`));
string candy_cane_weapon_damage;

if(weapon_damage_matcher.find()){
  candy_cane_weapon_damage = weapon_damage_matcher.group(1);
}

maximize(`Weapon damage percent, weapon damage, switch left-hand man, {candy_cane_weapon_damage} bonus Candy Cane Sword Cane, {(my_basestat($stat[muscle]) >= 150) ? "" : "-equip stick-knife of loathing"}`, false);
equip_stick_knife();

cs_test(6);
}



void spell_damage_test(){


camel_spit();
melf_buff();

if(get_property("lcs_use_birds") == "During Weapon or Spell Damage Test"){
  if(get_property("_birdOfTheDayMods").contains_text("Spell")){
    use_skill(1, $skill[Visit your Favorite Bird]);
  }
}

if(get_property("lcs_rem_witchess_witch") == "Yes (Before spell damage test)" && !available_amount($item[battle broom]).to_boolean()){
  print("Recalling that one time when you were reincarnated as a witchess witch.","teal");

  if(my_hp() * 1.3 > my_maxhp()){
    cli_execute("hottub");
  }

  maximize("10 weapon damage, -1 moxie, -1 muscle, -10 ml, 1000 bonus fourth of may cosplay saber, -equip combat lover's locket", false);
  refresh();

  string combat_filter = "sub LTS; if hasskill Lunging Thrust-Smack; skill Lunging Thrust-Smack; endif; endsub; call LTS; repeat !times 9; attack; repeat !times 9";
  if(!witchess_fight($monster[Witchess Witch], combat_filter)){
    visit_url("inventory.php?reminisce=1", false);
    visit_url("choice.php?whichchoice=1463&pwd&option=1&mid=1941");

    run_combat(combat_filter);
  } 
}


if(my_adventures() < 2){
  gain_adventures(1);
}

//TODO iterate over all of these and not use simmer if the sum of all of them is > 100% spell damage
if(!have_effect($effect[Simmering]).to_boolean() && have_skill($skill[Simmer]) && have_effect($effect[Spit upon]) != 1 && get_property("lcs_use_simmer") != "No"){
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

maximize(`Spell damage, spell damage percent, switch left-hand man, {(my_basestat($stat[muscle]) >= 150) ? "" : "-equip stick-knife of loathing"}`, false);



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


  foreach fam in $familiars[Left-hand Man, Disembodied Hand]{
    if(have_familiar(fam)){
      use_familiar(fam);
      if(equipped_item($slot[Familiar]) != $item[none]){
        equip($slot[Familiar], $item[none]);
      }
    }
  }


  if(available_amount($item[Beach Comb]).to_boolean()){
    cli_execute(`try; combo {11 - get_property("_freeBeachWalksUsed").to_int()}`);
  }

  if(my_level() >= 5){
    cli_execute(`make {mainstat_pizza}`);
  } 

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

void main(string... settings){

buffer ccs;
ccs.append("[default]");
ccs.append("\n");
ccs.append("consult LCSWrapperCombat.ash");

write_ccs(ccs, "lcswrapper_combat_script");

boolean prefs_changed = false;
string[string] script_preferences = { 
  // Buying Borrowed time from the Mall/other pulls
  "autoSatisfyWithNPCs":"true",
  "autoSatisfyWithCoinmasters":"true",
  "autoSatisfyWithMall":"true",

  // Removing automatic HP restores
  "hpAutoRecovery":"-0.05",
  "autoAbortThreshold":"0.0",
  "manaBurningThreshold":"-0.05",
  "mpAutoRecovery":"-0.05",

  // Reset moods and custom combat/afteradventure scripts
  "currentMood":"apathetic",
  "customCombatScript":"lcswrapper_combat_script",
  "betweenBattleScript":"",
  "afterAdventureScript":"",

  // June cleaver preferences
  "choiceAdventure1467":"3",
  "choiceAdventure1468":"2",
  "choiceAdventure1469":"3",
  "choiceAdventure1470": my_primestat() == $stat[Muscle] ? "3" : "2",
  "choiceAdventure1471":"1",
  "choiceAdventure1472":"1",
  "choiceAdventure1473":"1",
  "choiceAdventure1474": my_primestat() == $stat[Muscle] ? "3" : "1",
  "choiceAdventure1475":"1" 

  // Autorestore prefs
  "hpAutoRecoveryItems": "cannelloni cocoon;tongue of the walrus;lasagna bandages;doc galaktik's homeopathic elixir",
  "mpAutoRecoveryItems": "doc galaktik's invigorating tonic;soda water;",
};



try {
  string[int] options = settings.join_strings(" ").split_string(" ");

  boolean[string] available_choices;
  foreach it in $strings[
    help,
    ascend,
    start,
    setup,
    preferences,
    changelog,

    skipleveling,
    powerlevel,

    summary,
    sekrit,
  ] available_choices[it] = false;

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

  string current_script_ver = "v1.51";


  if(get_property("lcs_start") != current_script_ver || available_choices["changelog"]){

    newline();

    if(get_property("lcs_start") == ''){ // No property
      print("Hello! Thanks for running this script for the first time!");
      print("Since this is your first and only time you'll see this screen, we've set a couple of settings for you.");
      print("If you ever want to adjust these changes, please run the `setup` command!");

      newline();

      if(have_familiar($familiar[Pair of Stomping Boots])){
        set_property("lcs_skip_borrowed_time", "Yes");
      }

      if(get_property("goorbo_clan") != ""){
        set_property("lcs_clan", get_property("goorbo_clan"));
      }

      set_property("lcs_start", current_script_ver);
      abort("Please run the script again to continue!");
    }

    if(!get_property("lcs_start").contains_text('v1.4') && !get_property("lcs_start").contains_text('v1.5')){ 
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
    } // TODO: git_info()
  

    print(`Welcome back, {my_name()}! Here's what changed:`, "teal");
    print(`We fixed the relay script!`, "teal");
    // Fix previous invalid pref naming
    
    if(get_property("lcs_skip_borrowed_time") == "true"){
      set_property("lcs_skip_borrowed_time", "Yes");
    }


    newline();

    if(get_property("lcs_use_beta_version").to_lower_case() == "yes"){
      set_property("lcs_skip_borrowed_time", "Yes");
    }

    if(available_choices["changelog"]){
      abort("That's the latest changelog!");
    }

    set_property("lcs_start", current_script_ver);
    newline();

    wait(10);
  }

  if(get_property("lcs_skip_borrowed_time").to_boolean()){
    if(available_choices["sekrit"]){
      sekrit();
    }
  }

  if(available_choices["help"]){

  string[int] print_html_sucks_ass = {
    "skipleveling | This will skip powerleveling, if you encounter a bug and cannot continue during powerleveling.",
    "summary | This outputs a summary of your last recorded run, including turns used and time taken.",
    "help | This displays this window! Yay!.",
    "setup | Need to modify or adjust the script? Run this setting!",
    "preferences | Displays all the script preferences, for fine-tuning or debugging.",
    "changelog | Ooh, what's new? Run this to check again!",
    "sim | Check if you can run the script.",
  };

    print_html("<font size=4><b><font color=D3D3D3><center> Help: </center><font></b></font>");
    print_html("<b><font color=d3d3d3> Contrary to the 'Wrapper' name, this is a CS script, and should work for any class and any moon! </b></font>"); 

    foreach x, it in print_html_sucks_ass {
      print_html(`<b><font color=66b2b2>{it.split_string("\\ \\|\\ ")[0]}</b></font> - {it.split_string("\\ \\|\\ ")[1]}`);
    }

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

  if(available_choices["preferences"]){
    list_preferences();
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

  foreach pref, setting in script_preferences {
    string temp = get_property(pref);
    set_property(pref, setting);

    script_preferences[pref] = temp;
  }

  prefs_changed = true;

  // 30m has passed since you last ran it. Maybe use prop. ascensionsToday?
  if(get_property("lcs_time_at_start").to_int() + 1800000 < now_to_int()){
    set_property("lcs_time_at_start", now_to_int());
  }

  string clan_at_start = get_clan_name();

  if(get_property("lcs_clan") != ""){
    cli_execute(`/whitelist {get_property("lcs_clan")}`);
  }

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

  string[int] default_cs_test_order = {
      "mys / Build Playground Mazes",
      "mox / Feed Conspirators",
      "mus / Feed The Children",
      "hp / Donate Blood",
      "item / Make Margaritas",
      "hot_res / Clean Steam Tunnels",
      "fam_weight / Breed More Collies",
      "non_combat / Be a Living Statue",
      "weapon_damage / Reduce Gazelle Population",
      "spell_damage / Make Sausage"
    };

  if(get_property("lcs_test_order_override") == ""){

    foreach num, cs_test in default_cs_test_order {
      if (!contains_text(get_property("csServicesPerformed"), cs_test.split_string("\\ \\/\\ ")[1])){ 
        test(cs_test.split_string("\\ \\/\\ ")[0]);
      }
    }
    
  } else {
  string [int] indv_tests = split_string(get_property("lcs_test_order_override").to_lower_case(), "\\, ");

  for i from 0 to (count(indv_tests) - 1) {
  switch(indv_tests[i]){
    case "mys":
    case "mysticality":
      if (!contains_text(get_property("csServicesPerformed"), "Build Playground Mazes")){ 
        test("mys");
      }
    break;

    case "mox":
    case "moxie":
      if (!contains_text(get_property("csServicesPerformed"), "Feed Conspirators")){
        test("mox");
      }
    break;

    case "mus":
    case "muscle":
      if (!contains_text(get_property("csServicesPerformed"), "Feed The Children")){
        test("mus");
      }
    break;

    case "hp":
    case "health":
    case "blood":
      if (!contains_text(get_property("csServicesPerformed"), "Donate Blood")){
        test("hp");
      }
    break;

    case "hot res":
    case "hot_res":
    case "hot resistance":
    case "hot_resistance":
      if (!contains_text(get_property("csServicesPerformed"), "Clean Steam Tunnels")){
        test("hot_res");
      }
    break;

    case "non combat":
    case "non_combat":
    case "non-combat":
    case "-combat":
      if (!contains_text(get_property("csServicesPerformed"), "Be a Living Statue")){
        test("non_combat");
      }
    break;

    case "item":
    case "item drop":
    case "item_drop":
    case "booze":
    case "booze drop":
    case "booze_drop":
      if (!contains_text(get_property("csServicesPerformed"), "Make Margaritas")){
        test("item");
      }
    break;

    case "famwt":
    case "fam weight":
    case "fam_weight":
    case "familiar_weight":
    case "familiar weight":
      if (!contains_text(get_property("csServicesPerformed"), "Breed More Collies")){
        test("fam_weight");
      }
    break;

    case "weapon damage":
    case "weapon_damage":
    case "weapon dmg":
    case "weapon_dmg":
      if (!contains_text(get_property("csServicesPerformed"), "Reduce Gazelle Population")){
        test("weapon_damage");
      }
    break;

    case "spell damage":
    case "spell_damage":
    case "spl_damage":
    case "spl damage":
      if (!contains_text(get_property("csServicesPerformed"), "Make Sausage")){
        test("spell_damage");
      }
    }
  }
  }


  if(get_property("csServicesPerformed").split_string(",").count() == 11 && get_property("lcs_break_prism").to_lower_case() != "false"){
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
  print(`Organ use: {my_fullness()} fullness, {my_inebriety()} drunkeness{available_amount($item[Designer Sweatpants]).to_boolean() ?  " (" + get_property("_sweatOutSomeBoozeUsed") + "/3 sweat out some booze used)" : ""}, {my_spleen_use()} spleen`, "lime");
  newline();
  print("Summary:", "green");
  summary(false);
}

finally {
  print(get_property("csServicesPerformed").split_string(",").count() == 11 || !prefs_changed ? "" : "Early abort! Uh-oh.", "red");

  if(prefs_changed) {
    cli_execute(`/whitelist {clan_at_start}`);  

    foreach pref, setting in script_preferences {
      set_property(pref, setting);
    }
  }
}

}
