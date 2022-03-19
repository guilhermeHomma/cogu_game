extends Control



var _scene
onready var stage = preload("res://scene/world.tscn")
onready var player = preload("res://scene/player.tscn")

func _ready():
	$ip.text = "127.0.0.1"
	$nome.text = "jogador 1"
	Networking.Menu = self
	
	pass
	
func _on_voltar_button_pressed():
	_scene = get_tree().change_scene("res://scene/menu.tscn")
	Networking.disconectado_do_servidor(Networking.Pegar_Identificador())
	Atualizar_Lista_Jogadores()
	pass


func _on_entrar_button_pressed():
	Networking.Mudar_Ip($ip.text)
	Networking.Mudar_Nome($nome.text)
	Networking.Entrar()

	
	$criar_button.disabled = true
	$entrar_button.disabled = true
	
	pass # Replace with function body.


func _on_criar_button_pressed():
	Networking.Mudar_Ip($ip.text)
	Networking.Mudar_Nome($nome.text)
	Networking.Criar()

	$criar_button.disabled = true
	$entrar_button.disabled = true
	$ipshow.text = "Endereço IP: "+str(Networking.Pegar_Endereco_Ip())
	
	$iniciar_button.disabled = false
	pass # Replace with function body.

remotesync func Iniciar_Jogo():
	var stg = stage.instance()
	var _player = null
	var Lista = Networking.Pegar_Lista_Jogadores()
	
	get_parent().call_deferred("add_child", stg)
	stg.set_network_master(Lista[0][0])
	
	for numero_jogador in Networking.Numero_Jogadores:

		_player = player.instance()
		_player.position = Vector2(rand_range(-180,-230),-470)
		_player.set_network_master(Lista[numero_jogador][0])
		stg.call_deferred("add_child", _player)
	
	
	
	Networking.Menu = null
	queue_free()

	
	pass
	
func Atualizar_Lista_Jogadores():
	var Lista = Networking.Pegar_Lista_Jogadores()
	var ID = Networking.Pegar_Identificador()
	var Num = Networking.Pegar_Numero_Jogadores()
	$lista_jogadores.clear()
	for i in range(Num):
		if Lista[i][0] == ID:
			$lista_jogadores.add_item(str(Lista[i][1]) +str("(você)"))
		else:
			$lista_jogadores.add_item(Lista[i][1])
			
	pass

remote func Teste():


	print("entrou alguem")


func _on_iniciar_button_pressed():
	rpc("Iniciar_Jogo")
	pass # Replace with function body.
