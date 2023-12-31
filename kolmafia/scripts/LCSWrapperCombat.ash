
script "LCSWrapperCombat.ash";
import <LCSWrapperResources.ash>
// LCSWrapperCombat - Uh, combat?

string delevel(monster mon){
    buffer delevel_macro = "";
    // TODO. Check MP

    if(my_class() == $class[Sauceror] && have_skill($skill[Curse of Weaksauce]) && have_skill($skill[Itchy Curse Finger]) && (my_mp() > 10)){
        delevel_macro.append("skill curse of weaksauce;");
    }

    if(have_skill($skill[Surprisingly Sweet Slash])){
        delevel_macro.append("skill surprisingly sweet slash;");
    }

    if(have_skill($skill[Micrometeorite])){
        delevel_macro.append("skill micrometeorite;");
    }
    // after deleveling
    boolean safe_encounter = expected_damage(mon) <= 0.1 * my_hp();

    if(safe_encounter){

        if(have_skill($skill[Extract])){
            delevel_macro.append("skill extract;");
        }

        if(have_skill($skill[Extract Jelly]) && mon.monster_element() == $element[stench]){
            delevel_macro.append("skill extract jelly;");
        }

        if(have_skill($skill[Sing Along])){
            delevel_macro.append("skill sing along;");
        }
    }


    return delevel_macro.to_string();
}

string auto_attack(){
    buffer auto_attack_macro = "";

    if(have_skill($skill[Surprisingly Sweet Stab])){
        auto_attack_macro.append("skill Surprisingly Sweet Stab;");
    }

    if(have_skill($skill[Cincho: Projectile Piñata]) && get_property("lcs_seventy") == "true"){
        auto_attack_macro.append("sub PP; if hasskill Cincho: Projectile Piñata; skill Cincho: Projectile Piñata; endif; endsub; call PP; repeat !pastround 15;");
    }

    return auto_attack_macro.to_string() + "attack; repeat !pastround 25; abort;";
}




string freekill(){

    if(have_skill($skill[Chest x-ray])){
        return "skill Chest x-ray;";
    }

    if(have_skill($skill[Shattering Punch])){
        return "skill Shattering Punch;";
    }

    if(have_skill($skill[Gingerbread Mob Hit])){
        return "skill Gingerbread Mob Hit;";
    }

    if(have_skill($skill[Shocking lick])){
        return "skill Shocking lick;";
    }

    if(item_amount($item[Groveling Gravel])){
        return "use Groveling Gravel;";
    }

    return "abort \"No freekills left!\";";
}


string freerun(){
    if((my_familiar() == $familiar[Pair of Stomping Boots] || (my_familiar() == $familiar[Frumious Bandersnatch] && have_effect($effect[Ode to Booze]).to_boolean())) && (get_property("_banderRunaways").to_int() + 1) * 5 >= numeric_modifier("Familiar Weight")){
        return "run away";
    }

    if(have_skill($skill[Throw latte on opponent])){
        return "skill throw latte on opponent";
    }

    if(item_amount($item[cosmic bowling ball]).to_boolean() && my_level() > 14){
        return "skill bowl a curveball";
    }

    if(have_skill($skill[Reflex Hammer])){
        return "skill reflex hammer";
    }

    if(get_property("_snokebombUsed").to_int() < 3 && have_skill($skill[snokebomb])){
        return "skill snokebomb";
    }

    if(get_property("_feelHatredUsed").to_int() < 3 && have_skill($skill[Feel Hatred])){
        return "skill feel hatred";
    }

    return `abort \"Ran out of freeruns!\"`;
}


string main(int round, monster encounter, string page) {

location loc = my_location();
int safe_rounds = my_familiar() == $familiar[Left-hand Man] || my_familiar() == $familiar[Stomping Boots] ? (ceil(encounter.monster_hp() /  numeric_modifier("Familiar Weight") * 1.5)) : 31;
        
switch (encounter) {

    case $monster[Piranha plant]:
        encounter.delevel() + autoattack();

    case $monster[novelty tropical skeleton]:
        return "skill spit jurassic acid";

    case $monster[Mother Slime]:
        if(item_amount($item[cosmic bowling ball]).to_boolean()){
            return "skill bowl a curveball";
        }

        if(have_skill($skill[kgb tranquilizer dart])){
            return "skill kgb tranquilizer dart";
        }

        if(get_property("_snokebombUsed").to_int() < 3 && have_skill($skill[snokebomb])){
            return "skill snokebomb";
        }

        abort("Encountered mother slime with no way to retain inner elf!");


    case $monster[candied yam golem]:
    case $monster[malevolent tofurkey]:
    case $monster[possessed can of cranberry sauce]:
    case $monster[stuffing golem]:
    case $monster[novia cad&aacute;ver]:
    case $monster[novio cad&aacute;ver]:
    case $monster[padre cad&aacute;ver]:
    case $monster[persona inocente cad&aacute;ver]:
    case $monster[migratory pirate]:
    case $monster[peripatetic pirate]:
    case $monster[ambulatory pirate]:
        freerun();


    case $monster[Witchess Knight]:
    case $monster[Witchess Bishop]:
        encounter.delevel() + autoattack();
        




    default:
        abort("We encountered a monster not supported, whoops! If you're encountering this outside of LCSWrapper, set your CSS to default.");
}

return "abort"; 
}
