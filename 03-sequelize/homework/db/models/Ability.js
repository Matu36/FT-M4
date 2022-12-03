const { DataTypes } = require('sequelize');

module.exports = sequelize => {
  sequelize.define('Ability', {

    name: {
      type: DataTypes.STRING,
      allowNule: false,
      unique: "composite_unique"
    },

    description: {
      type:DataTypes.TEXT,
      
    },

    mana_cost: {
type: DataTypes.FLOAT,
allowNule: false,
unique:"composite_unique",
validate: {
  min: 10.0,
  max: 250.0
    },
  },

summary: {
  type: DataTypes.VIRTUAL,
  get() {
    return `${this.name} (${Math.trunc (this.mana_cost)} points of mana) - Description: ${this.description}`
  }
}
  })
}