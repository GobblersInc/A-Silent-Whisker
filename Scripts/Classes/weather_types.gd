extends Object

class_name Weather_Types

const RAIN : String = "Rain"
const SNOW : String = "Snow"
const WIND : String = "Wind"
const SUN : String = "Sun"

# Possible duo weather options
const Valid_Weather_Pairs : Array[Array] = [Weather_Pair01, Weather_Pair02, Weather_Pair03, Weather_Pair04]
const Weather_Pair01 : Array[String] = [RAIN, WIND]
const Weather_Pair02 : Array[String] = [RAIN, SUN]
const Weather_Pair03 : Array[String] = [SNOW, WIND]
const Weather_Pair04 : Array[String] = [WIND, SUN]
