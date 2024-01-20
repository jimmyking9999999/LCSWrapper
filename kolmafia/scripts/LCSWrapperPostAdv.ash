
// Cincho
if((get_property("timesRested").to_int() < total_free_rests()) && (get_property("_cinchUsed").to_int() > 30)) {
    if(get_property("chateauAvailable").to_boolean()) {
        visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");
    } else if (get_property("getawayCampsiteUnlocked").to_boolean()) {
        visit_url("place.php?whichplace=campaway&action=campaway_tentclick");
    } else {
        visit_url("campground.php?action=rest");
    }
}

// TODO Autosell worthless items

// June Cleaver
if(get_property("_juneCleaverFightsLeft") == 0 && have_equipped($item[June Cleaver])){
    adv1($location[Noob Cave], -1, "abort");
}

// Beaten up
if(have_effect($effect[Beaten Up]).to_boolean()){
    string [int] cleaverQueue = get_property("juneCleaverQueue").split_string(","); 

    if(cleaverQueue[cleaverQueue.count() - 1] == "1467" || cleaverQueue[cleaverQueue.count() - 1] == "1471"){ 
      use_skill($skill[Tongue of the Walrus]);
    } else {
      abort("We got beaten up =(");
    }
}

// Garbage shirt abort fix
if(get_property("garbageShirtCharge") == "1" && have_equipped($item[Garbage Shirt])){
    maximize(`{my_primestat()}, 4 ML, 3 {my_primestat()} exp, 1.33 exp, 30 {my_primestat()} experience percent, 3 familiar exp, 160 bonus candy cane sword cane, 8000 bonus designer sweatpants, 90 bonus unbreakable umbrella, -equip i voted, -equip Kramco Sausage-o-Matic, -equip makeshift garbage shirt, 100 bonus Cincho de Mayo`, false); 
    cli_execute("fold wad of used tape");
}
