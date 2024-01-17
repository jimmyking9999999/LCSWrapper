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
    "lcs_use_simmer | Do you wish to cast simmer for the spell damage test to save a turn? (Note that the script will automatically not cast it if you have spell damage effects at one turn) | Yes/No | have_skill($skill[Simmer])",
    "lcs_hatter_buff | Which hatter buff would you like the script to obtain? | Weapon Damage/Spell Damage/Familiar Weight/None",
    "lcs_rem_witchess_witch | Would you like to reminiscence a witchess witch instead of a bishop? | Yes (Before Powerleveling)/Yes (Before Spell damage test)/No | available_amount($item[Combat Lover's Locket])",
    "lcs_get_red_eye | Would you like the script to reminisce a red skeleton for a red eye? | Yes/No",
    "lcs_speakeasy_drinks | Would you like the script to drink anything from the speakeasy? | None/Bee's Knees Only/Sockdollager Only/Hot Socks Only/Bee's Knees and Sockdollager/Bee's Knees and Hot Socks/Sockdollager and Hot Socks/Bee's Knees, Sockdollager, and Hot Socks",
    "lcs_get_warbear_potion | Would you like the script to obtain (wish or pull) new and improved or experimental G-9 before powerleveling? | Yes/No",
    "lcs_get_a_contender | What about the 'A Contender' buff? | Yes/No",
    `lcs_wish_mainstat_percent | Would you like to wish for a 50 mainstat experience percent buff? | Yes/No`,
    "lcs_vip_fortune_buff | Which fortune teller buff would you like to obtain? | Mys/Mus/Mox/Familiar/Item/None",
    "lcs_make_camel_equip | Would you like to use a clip art cast for your melodramedary's familiar equipment? | Yes/No | (have_familiar($familiar[Melodramedary]) && have_skill($skill[Summon Clip Art]))",
    "lcs_use_nellyville | Would you like the script to use a Charter: Nellyville for extra help during powerleveling? | Yes/No | item_amount($item[2002 Mr. Store Catalog])",
    "lcs_alloted_backup_uses | How many backup camera uses would you like to use for powerleveling? | USER | available_amount($item[Backup Camera])",
    "lcs_use_witchess | How many witchess fights would you like the script to use? | 5/4/3/2/1/0 | get_campground()[$item[Witchess Set]]",
    "lcs_floundry | Which floundry item do you want to get? | Codpiece/Fish Hatchet/Tunac/Carpe/None",
    "lcs_august_scepter | Which buffs would you like for the August scepter? | Offhand Remarkable Before Powerleveling/Offhand Remarkable After Familiar Weight Test/Offhand Remarkable Before Non-Combat Test/None | available_amount($item[August Scepter])",
    "lcs_use_birds | Would you like to use your bird-a-day cast? (Sorry. It's yet to be dynamic) | Before Powerleveling/During Item Test/During Weapon or Spell Damage Test/None | item_amount($item[Bird-a-Day calendar])",
    "lcs_melf_slime_clan | Which clan would you like to use to obtain effect 'Inner elf'? | USER | have_familiar($familiar[Machine Elf])",
    "lcs_prof_lecture | Do you want to use all your pocket professor lectures on sausage goblins? | Yes/No | have_familiar($familiar[Pocket Professor])",
    "lcs_get_cbb_vegetable | Would you like to spend 11 familiar turns with the Cookbookbat for a Vegetable of Jarlsberg? (Myst class exclusive) | Yes/No | have_familiar($familiar[Cookbookbat])",
    "lcs_skip_filtered_water | Would you like to skip creating a cold-filtered water? | Yes/No | have_skill($skill[Summon Clip Art])",
    "lcs_deck_usage | What do you want to cheat with your deck? | Green Mana/Rope/Mickey Mantle/Green Mana + Rope/Mickey Mantle + Rope/Mickey Mantle + Green Mana/None | available_amount($item[Deck of Every Card])",

    "lcs_skip_borrowed_time | Would you like to have the script skip pulling/creating borrowed time? (Will pull your mainstat CBB legend dish or make a perfect drink!) Only enable this if you have >4 freeruns! | Yes/No",
    "lcs_skip_source_terminal | Would you like to skip getting items.enh from your source terminal? | Yes/No",
};

// Manual/automatic prefrences to set with `set x = y`, mainly for debugging
string [int] manual_preferences = {
    "lcs_excluded_buffs | Names of buffs to be excluded from get_effect(), seperated by comma ",
    "lcs_skip_yoked | Acquire holiday yoked from NEP monsters? Automatically set to false if needed.",
    "lcs_start | Script version!",
    "lcs_time_at_start | Time of script start. Requires at least 30 minutes of downtime to update",
    "lcs_autopull_at_start | Names of items to be automatically pulled at the start, seperated by comma",
    "lcs_break_prism | Avoids breaking the prism when set to 'false', for PVP or trophy reasons",
    "lcs_wish_limit | Wish limit!",
    "lcs_test_order_override | Test order override, seperated by comma. E.g 'mys, mox, mus, hp, hot res, non combat, item, fam weight, weapon damage, spell damage'", 
    "lcs_seventy | Disregard resources in order to get a 1/70 CS run when set to 'true'"
    
};

///
boolean change_pref(int which_preference){
    /* preference_details: 0 => Mafia pref, 1 => Description, 2 => Options, 3 => Conditional (maybe) */ 
    string [int] preference_details = split_string(preferences[which_preference], "\\ \\|\\ ");

    if(preference_details.count() == 4){    
        if(cli_execute_output(`ash {preference_details[3]}.to_boolean()`).contains_text(false)){
            print(`Skipping preference {preference_details[0]}, as you do not have the prerequisite(s). =(`);
            return false;
        }
    }

    string [int] choices = split_string(preference_details[2], "\\/");
    string user_choice;

    switch(choices.count()){
        case 0: break; // i dunno, man
        case 1:
            user_choice = user_prompt(preference_details[1]).to_string();
        break;

        default:
            string[string] choiceDictionary;
            for (int i = 0; i < min(choices.count(), 11); i++) {
                choiceDictionary[choices[i]] = choices[i];
            }
            user_choice = user_prompt(preference_details[1], choiceDictionary).to_string();
        break;
    }

    if(user_choice == "" && get_property(preference_details[0]) != ""){
        print(`Skipping! (Your last selection was '{get_property(preference_details[0])}')`, "teal");
        return false;
      } else {
        print(`Setting perference '{preference_details[0]}' to '{user_choice}'!`, "teal");
        set_property(preference_details[0], user_choice);
        return true;
      }
}

void script_setup(){
    print("Setting up your script! Press ESC or click the 'x' to use your previous settings.");
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

void list_preferences(){
    print_html("<b><font color=D3D3D3>In-script setup preferences:</b></font>");
    foreach num, pref in preferences {
        string [int] details = split_string(pref, "\\ \\|\\ ");
        print_html(`<b><font color=66b2b2>{details[0]}</b></font> - {details[1]}`);
    }
    newline();
    print_html("<b><font color=D3D3D3>User-set setup preferences:</b></font>");
    foreach num, pref in manual_preferences {
        print_html(`<b><font color=66b2b2>{pref.split_string("\\ \\|\\ ")[0]}</b></font> - {pref.split_string("\\ \\|\\ ")[1]}`);
    }
}



string flavour_text(string stage_name){
    switch(stage_name){	
    default:
        abort("You didn't enter a valid stage number");
    case "1":
        return "completing post-ascension tasks!";
    case "2":
        return "coiling some wires!";
    case "3":
        return "powerleveling.";
    case "4":
    case "mys":
        return "building playground mazes! (Myst test)";
    case "5":
    case "mox":
        return "feeding conspirators. (Mox test)";
    case "6":
    case "mus":
        return "feeding children (but not too much) (Mus test)";
    case "7":
    case "hp":
        return "donating blood! (HP test)";
    case "8":
    case "item":
        return "making margaritas. (Item / Booze test)";
    case "9":
    case "hot_res":
        return "cleaning some steam tunnels! (Hot Resistance test)";
    case "10":
    case "fam_weight":
        return "...encouraging collie breeding. (Familiar weight test)";
    case "11":
    case "non_combat":
        return "staying very, very still. (Non-combat test)";
    case "12":
    case "weapon_damage":
        return "reducing the local wizard gazelle population. (Weapon damage test)";
    case "13":
    case "spell_damage":
        return "making sausages. (Spell damage test)";
    }
}

void summary(boolean revisit){
    // TODO: Fix this. Maybe add preferences with _ in order for     them to be removed at the end of the day?
    boolean colourdown; int colour = 9264;  

    int prev_time = get_property("lcs_time_at_start").to_int();


    string [int] indv_tests;

    if(get_property("lcs_test_order_override") != ""){ 
        indv_tests = split_string(get_property("lcs_test_order_override"), "\\, ");
    } else {
        indv_tests = {"mus", "mox", "hp", "item", "hot res", "fam weight", "non combat", "weapon damage", "spell damage"};
    }

    print("We took "+((get_property("post_time_oriole").to_int() - get_property("lcs_time_at_start").to_int())/1000)+" seconds and "+(get_property("post_advs_oriole").to_int())+" adventure(s) completing post-ascension tasks!", 9088);
    print("We took "+((get_property("post_time_wire").to_int() - get_property("post_time_oriole").to_int())/1000)+" seconds and "+(get_property("post_advs_wire").to_int() - get_property("post_advs_oriole").to_int())+" adventures coiling some wires!", 9176);
    print("We took "+((get_property("post_time_powerlevel").to_int() - get_property("post_time_wire").to_int())/1000)+" seconds and "+(get_property("post_advs_powerlevel").to_int() - get_property("post_advs_wire").to_int())+" adventures powerleveling.", 9264);

    int total_adventures = get_property("post_advs_powerlevel").to_int();

    foreach num, test in indv_tests {

        colour = colourdown ? colour - 88 : colour + 88; 

        if(colour == 9704) { 
            colourdown = true; 
        }
    
        /* Turns spaces into underscores */
        matcher space = create_matcher(" ", test);
        string testname = replace_first(space, "_");
        /* indiv_test_info : [0] => pre test turn amount. [1] => pre test time. [2] => post test turn amount. [3] => post test time. */
        string [int] indiv_test_info = split_string(`{get_property(`lcs_pre_test_info_{testname}`)} | {get_property(`lcs_post_test_info_{testname}`)}`, " \\| ");

        if(count(indiv_test_info) == 4){
            int test_adv_amount = (indiv_test_info[2].to_int() - indiv_test_info[0].to_int());
            int test_second_amount = (indiv_test_info[3].to_int() - indiv_test_info[1].to_int())/1000;
            
            print(`We took {test_second_amount > 0 ? test_second_amount.to_string() : "?"} seconds and {test_adv_amount} adventure{is_plural(test_adv_amount)} {flavour_text(testname)}`, colour);
            total_adventures += test_adv_amount;
        }   
    }

    if(revisit){
        newline();
        print(`In total, your last CS run took {total_adventures} adventures!`, "teal");
    }   
  

    if(my_id() == "3589231"){
        print("Oh, and you're super handsome =3", "lime");
    }
}
  

void script_req_sim(){
    abort("Sorry, this doesn't quite work right now! Nag me on Discord to fix it <3");
}
