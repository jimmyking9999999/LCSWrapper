script "LCSWrapperMenu.ash";
import <LCSWrapperResources.ash>

// LCSWrapperMenu. Controls the various knobs and buttons to customize your experience, look at your runs, and whatnot
// Relay script soon? maybe.

// List of all preferences
string [int] preferences = {
    "lcs_turn_threshold_mys | What would you like your mysticality stat test turn threshold to be? | USER",
    "lcs_turn_threshold_mox | What would you like your moxie stat test turn threshold to be? | USER",
    "lcs_turn_threshold_mus | What would you like your muscle stat test turn threshold to be? | USER",
    "lcs_turn_threshold_hp | What would you like your HP test turn threshold to be? | USER",
    "lcs_turn_threshold_item | What would you like your item test turn threshold to be? | USER",
    "lcs_turn_threshold_hot_res | What would you like your hot resistance test turn threshold to be? | USER",
    "lcs_turn_threshold_fam_weight | What would you like your familiar weight test turn threshold to be? | USER",
    "lcs_turn_threshold_non_combat | What would you like your non-combat test turn threshold to be? | USER",
    "lcs_turn_threshold_weapon_damage | What would you like your weapon damage test turn threshold to be? | USER",
    "lcs_turn_threshold_spell_damage | What would you like your spell damage test turn threshold to be? | USER",


    "lcs_clan | Which clan would you like the script to use as your VIP clan? | USER",
    "lcs_get_cyclops_eyedrops | Would you like the script to get cyclops eyedrops for the item test? | Yes/No",
    "lcs_hatter_buff | Which hatter buff would you like the script to obtain? | Weapon Damage/Spell Damage/Familiar Weight/None",
    "lcs_rem_witchess_witch | Would you like to reminiscence a witchess witch instead of a bishop? | Yes (Before Powerleveling)/Yes (Before spell damage test)/No",
    "lcs_get_red_eye | Would you like the script to reminisce a red skeleton for a red eye? | Yes/No",
    "lcs_speakeasy_drinks | Would you like the script to drink anything from the speakeasy? | None/Bee's Knees Only/Sockdollager Only/Hot Socks Only/Bee's Knees and Sockdollager/Bee's Knees and Hot Socks/Sockdollager and Hot Socks/Bee's Knees, Sockdollager, and Hot Socks",
    "lcs_get_warbear_potion | Would you like the script to obtain new and improved or experimental G-9 before powerleveling? | Yes/No",
    "lcs_get_a_contender | What about the 'A Contender' buff? | Yes/No",
    "lcs_vip_fortune_buff | Which fortune teller buff would you like to obtain? | Mys/Familiar/Item/None",
    "lcs_alloted_backup_uses | How many backup camera uses would you like to use for powerleveling? | USER",
    "lcs_floundry | Which floundry item do you want to get? | Codpiece/Fish Hatchet/Tunac/Carpe/None",
    "lcs_august_scepter | Which buffs would you like for the August scepter? | Offhand Remarkable Before Powerleveling/Offhand Remarkable After Familiar Weight Test/None",

    "lcs_use_beta_version | Would you like to have the script assume you at a higher shiny level? This will have the script redirect resources into harder tests. Only enable this if you have >4 freeruns and can always 1-turn stat tests! | Yes/No",
    
};

// Manual/automatic prefrences to set with `set x = y`, mainly for debugging
string [int] manual_preferences = {
    "lcs_excluded_buffs",
    "lcs_get_yoked",
    "lcs_start",
    "lcs_time_at_start",
};




///
void change_pref(int which_preference){
    /* preference_details: 0 => Mafia pref, 1 => Description, 2 => Options */ 
    string [int] preference_details = split_string(preferences[which_preference], "\\ \\|\\ ");
    string [int] choices = split_string(preference_details[2], "\\/");
    string user_choice;

    /* There's probably a better way of doing this, but it works lol */
    switch(choices.count()){
        default:
            abort("Invalid amount of choices!");
        case 0: break;
        case 1:
            user_choice = user_prompt(preference_details[1]).to_string();
        break;
        case 2:
            user_choice = user_prompt(preference_details[1], string [string] {choices[0]:choices[0], choices[1]:choices[1]} ).to_string();
        break;
        case 3:
            user_choice = user_prompt(preference_details[1], string [string] {choices[0]:choices[0], choices[1]:choices[1], choices[2]:choices[2]} ).to_string();
        break;
        case 4:
            user_choice = user_prompt(preference_details[1], string [string] {choices[0]:choices[0], choices[1]:choices[1], choices[2]:choices[2], choices[3]:choices[3]} ).to_string();
        break;
        case 5:
            user_choice = user_prompt(preference_details[1], string [string] {choices[0]:choices[0], choices[1]:choices[1], choices[2]:choices[2], choices[3]:choices[3], choices[4]:choices[4]} ).to_string();
        break;
        case 8:
            user_choice = user_prompt(preference_details[1], string [string] {choices[0]:choices[0], choices[1]:choices[1], choices[2]:choices[2], choices[3]:choices[3], choices[4]:choices[4], choices[5]:choices[5], choices[6]:choices[6], choices[7]:choices[7]} ).to_string();
        break;
    }

    if(user_choice == "" && get_property(preference_details[0]) != ""){
        print(`Skipping! (Your last selection was '{get_property(preference_details[0])}')`, "teal");
      } else {
        print(`Setting perference '{preference_details[0]}' to '{user_choice.to_lower_case()}'!`, "teal");
        set_property(preference_details[0], user_choice);
      }
}

void script_setup(){
    print("Setting up your script!");
    if(user_confirm("Would you like to set this script's turn threshold settings?")){
        newline();
        print("Setting turn thresholds! (How many turns do you want to complete each test in, at minimum)", "teal");
        print("E.g. 1 to cap the test, 45 to have the script buff you up to 45 or under and continue!", "teal");
        newline();
        print("If you're just starting the script, it's advised to set everything to a 1-turn threshold, and take a look at any unused buffs for tests that you cannot cap! Then DM Jimmyking on discord and bug them about said unused buffs!", "teal");

        for i from 0 to 9 {
            change_pref(i);
        }
    }

    if(user_confirm("Would you like to set this script's other settings?")){
        for i from 10 to (count(preferences) - 1) {
            change_pref(i);
        }

    }
}


void summary(){

string flavour_text(int stage_name){
	switch(stage_name){	
    default:
			abort("You didn't enter a valid stage number");
    case 1:
      return "completing post-ascension tasks!";
    case 2:
      return "coiling some wires!";
		case 3:
      return "powerleveling.";
		case 4:
      return "building playground mazes! (Myst test)";
		case 5:
      return "feeding conspirators. (Mox test)";
		case 6:
      return "feeding children (but not too much) (Mus test)";
		case 7:
      return "donating blood! (HP test)";
		case 8:
      return "making margaritas. (Item / Booze test)";
		case 9:
      return "cleaning some steam tunnels! (Hot Resistance test)";
		case 10:
      return "...encouraging collie breeding. (Familiar weight test)";
		case 11:
      return "staying very, very still. (Non-combat test)";
		case 12:
      return "reducing the local wizard gazelle population. (Weapon damage test)";
		case 13:
      return "making sausages. (Spell damage test) ";
  }
}
  // TODO: Fix this. Maybe add preferences with _ in order for them to be removed at the end of the day?

  boolean colourdown; int colour = 9000; 

  string prev_time = get_property("lcs_time_at_start").to_int();
  string time_taken;
  
  int prev_advs;
  int stage_number = 1;
  
  foreach it in $strings[post_time_oriole, post_time_wire, post_time_powerlevel, post_time_mys, post_time_mox, post_time_mus, post_time_hp, post_time_item, post_time_hot_res, post_time_fam_weight, post_time_non_combat, post_time_weapon_damage, post_time_spell_damage]{
    time_taken = ((get_property(it).to_int() - prev_time.to_int()) / 1000);
   
   if(colourdown){ colour -= 88; } else { colour += 88;} if(colour == 9704){ colourdown = true; }

    if((time_taken.to_int() < -1) || (time_taken.to_int() > 5000)){
      set_property(it, prev_time.to_int() - 1000);
    }

    string temp = substring(it, 10);

    int advs = to_int(get_property("post_advs_"+temp));
    
    if(time_taken == "-1"){
      time_taken = "?";
    }

    print(`We took {time_taken} seconds and {advs - prev_advs} adventure{is_plural(advs - prev_advs)} {flavour_text(stage_number)}`, `{colour}`);

    prev_advs = advs;
    prev_time = get_property(it);
    stage_number++;
  }

    if(my_id() == "3589231"){
        print("Oh, and you're super handsome =3", "lime");
    }
}
  

void script_req_sim(){

}


   