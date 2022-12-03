const { Router } = require('express');
const { Op, Character, Role } = require('../db');
const router = Router();

router.post ("./", async (req, res) => {
const {name, code, hp, mana} = req.body;

if (!name || !code || !hp || !mana);
res.status (404).send ("Falta enviar datos obligatorios");

try {
    const character =  await Character.Create (req.body)
    res.status(201).json (character);
}
catch(e) {
res.status(404).send ("Error en alguno de los datos provistos" )
}

}
)

//EJEMPLO DE FILTRADO DE PROPIEDADES

router.get ("/", async (req, res) => {

    try {
   const {race, age} = req.query;
   const condition = {};
   const where= {};
   if (race) where.race = race;
   if (age) where.age = age;
   condition.where = where;
   const character = await Character.findAll (condition);
   res.json (Character);
    }
    catch (error) {
        console.log(error);
    }
})


router.get ("/young", async (req, res) => {
try {
    const youngCharacters = await Character.findAll({
        where: {
            age: {
                [op.lt]: 25
            }
        }
    });
    res.send (youngCharacters);
} catch (error) {
    console.log(error);
    res.sendStatus (500);
}

    }
)


router.get ("/:code", async (req, res) => {

const {code} = req.params;
const character = await Character.findByPk (code);
if (!character) return res.status (404).send (`El código ${code} no corresponde a 
un personaje existente`)
res.json (Character);
})

router.put ("/addAbilities", async (req, res) => {
    const {codeCharacter, abilities} = req.body;
    let character = await Character.findByPk (codeCharacter);
    let abilitiesArray = abilities.map (el => character.createability (el));
    await Promise.all (abilitiesArray)
    })
    res.status (201).json (character);


router.put ("/:attribute", async (req, res) => {
    try {
    const {value} = req.query;
    const {attribute} = req.params;
    await Character.update (
        {[attribute]: value},
{
    where: {
        [attribute]: null
    }
}

    );
    res.send("Personajes actualizados")
    } catch (error) {
        console.log(error);
        res.sendStatus (500);
    }
})

router.get ("/roles/:code", async (req, res) => {
    
    try {
    const {code} = req.params;
    const character = await Character.findByPk (code, {
        include: Role
    });
    res.status(201).json (character)
    }
catch (error) {
    console.log(error)
}
})



module.exports = router;