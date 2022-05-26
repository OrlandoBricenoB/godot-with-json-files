extends Node

const path = "user://stats.json"

# Valor del Nodo
var stats:Dictionary = {}

# Valores por defecto.
const defaultStats = {
	"name": "Jo-Sword",
	"level": 1,
	"skills": [
		{
			"name": "Bola de Fuego",
			"level": 1,
			"uses": 30
		},
		{
			"name": "Gran incendio",
			"level": 2,
			"uses": 56
		}
	]
}

# Cuando el nodo ha sido agregado al árbol de escena.
func _ready():
	# Cargar los datos a la variable stats y actualizar el TextEdit.
	stats = getStats()
	updateTextEdit()

# El parámetro string es opcional.
func updateTextEdit(string = ''):
	var statsDataNode = get_node('/root/Main/UI/container/statsData')
	# Si se recibe el parámetro string.
	if statsDataNode && string:
		statsDataNode.text = string
		return

	# Si existe el nodo y hay datos para mostrar.
	if statsDataNode && stats:
		var statsJSON = to_json(stats)
		# Mostrarlos en pantalla como JSON.
		statsDataNode.text = statsJSON

# Actualizar el JSON con los datos por defecto.
func resetStats():
	# Duplicate para evitar problemas de referencia en los objetos.
	stats = defaultStats.duplicate()

	# Actualizar el archivo JSON con los datos por defecto.
	updateStats(stats)
	return stats

# Obtener datos del archivo JSON.
func getStats():
	var file = File.new()

	# Abrir el archivo.
	file.open(path, file.READ_WRITE)

	if !file.file_exists(path):
		file.close()
		return resetStats()

	# Obtener contenido en String.
	var jsonStringify = file.get_as_text()

	# Si está vacío o nulo, crear datos por defecto.
	if jsonStringify == 'null' or !jsonStringify:
		file.close()
		return resetStats()
	
	# Convertir String a Diccionario
	var statsDataNode = get_node('/root/Main/UI/container/statsData')
	statsDataNode.text = jsonStringify

	var jsonParsed = JSON.parse(jsonStringify).result

	# Si el tipo aún es String, convertirlo a diccionario.
	if typeof(jsonParsed) == TYPE_STRING:
		jsonParsed = parse_json(jsonParsed)
	
	# Cerrar archivo y regresar el valor obtenido.
	file.close()
	return jsonParsed

# Editar el archivo JSON.
func updateStats(newStats):
	if (!newStats): return stats
	# Para evitar conflictos, no acepta un string como parámetro.
	if typeof(newStats) == TYPE_STRING:
		print('No se actualiza con String.')
		return
	# También se puede agregar el tipo Array si necesitas un listado de registros.
	elif typeof(newStats) == TYPE_DICTIONARY:
		newStats = to_json(newStats)
	var file = File.new()

	# Abrir el archivo, sobreescribir y cerrarlo.
	file.open(path, file.WRITE)
	file.store_string(newStats)
	file.close()

	# Actualizar el textEdit con el nuevo contenido del JSON.
	updateTextEdit(newStats)

# Botón de Guardar Datos
func _on_saveData_button_up():
	var statsDataNode = get_node('/root/Main/UI/container/statsData')
	# Si no se encuentra el nodo, no hacer nada.
	if !statsDataNode: return

	# Obtener el JSON del contenido del TextEdit como un Diccionario.
	var newStats = JSON.parse(statsDataNode.text).get_result()

	updateStats(newStats)

# Botón de Obtener Datos
func _on_getData_button_up():
	# Obtener datos del JSON o los por defecto si no existe archivo.
	stats = getStats()
	updateTextEdit()

# Botón de Resetear Datos
func _on_resetData_button_up():
	# Actualizar las estadísticas a las por defecto.
	stats = resetStats()

# Botón de Cambiar Nombre
func _on_changeName_button_up():
	# Listado de nombres.
	var randomNames = [
		"Fara",
		"Riond",
		"Anbolod",
		"Fresp",
		"Jo-Sword",
		"Aronduste",
		"Kemal",
		"Gaurio"
	]
	
	# Crear un número aleatorio para las matrices del listado de nombres.
	var randomNumber = RandomNumberGenerator.new()
	randomNumber.randomize()
	var randomIndex = randomNumber.randi_range(0, 7)

	# Actualizar el nombre en los stats.
	var newStats = stats
	newStats.name = randomNames[randomIndex]
	updateStats(newStats)
