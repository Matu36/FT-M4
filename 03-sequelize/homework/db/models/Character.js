const { DataTypes } = require('sequelize');


module.exports = sequelize => {
  sequelize.define('Character', {

    code: {
      type: DataTypes.STRING(5),
  primaryKey: true,
  validateCode (value) {
    if (value.toLowerCase === "henry")
    throw new Error ("codigo incorrecto")
  }
    },
  
    name: {
      type: DataTypes.STRING,
      unique: true,
      validate: {
        notIn: ["Henry", "SoyHenry", "Soy Henry"]
      }
    },
    

  age: {
    type: DataTypes.INTEGER,
    get() {
      let value = this.getDataValue ("age");
      if (!value) return null;
      return value + "years old"
    }
  },

  race: {
    type: DataTypes.ENUM ('Human', 'Elf', 'Machine', 'Demon', 'Animal', 'Other'),
    defaultValue: "Other"
  },

  hp: {
    type: DataTypes.FLOAT,
  },

  mana: {
    type: DataTypes.FLOAT,

  },

  date_added: {
    type: DataTypes.DATEONLY,
    defaultValue: DataTypes.NOW

  },
  }, 
  {
    timestamps: false

  })
}