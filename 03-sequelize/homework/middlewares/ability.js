const { Router } = require('express');
const { Ability } = require('../db');
const router = Router();

router.post ("/", async (req, res) => {
    try {
        const {name, mana_cost} = req.body;
        if (!name || !mana_cost) return res.status (404).send ("Falta enviar datos obligatorios")
        const ability = await Ability.create (req.body);
        res.status (201).send (ability);
    } catch (error) {
        res.status (404).send ("Algo se rompio en el proceso")
    }
})

router.put ("/setCharacter", async (req, res) => {
const {idAbility, codeCharacter} = req.body;
try {
    let ability = await Ability.findByPk (idAbility);
    await ability.setCharacter (codeCharacter);
    let result = await Ability.findByPk (idAbility, {
        attributes: ["name", "description", "mana_cost", "CharacterCode"]
    })
    res.status (201).json (result);
}
catch (error) {
    console.log(error);
}

})


module.exports = router;