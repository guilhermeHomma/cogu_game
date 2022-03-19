extends Node

const IP_BASE = "127.0.0.1"
const PORTA_BASE = 8080
const MAX_JOGADORES = 2

var Ip = "127.0.0.1"
var ID = ""
var Nome = ""

var Peer = null
var Jogadores = []
var Numero_Jogadores = 0
var Menu = null

func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "conectado_no_servidor")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed",self,"erro_de_conexao")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self,"servidor_desconectado")
	pass
	
func conectado_no_servidor():
	rpc("Registrar_Jogador", get_tree().get_network_unique_id(),Nome)
	pass
	
func Pegar_Endereco_Ip():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192"):
			return ip
func disconectado_do_servidor(id):
	var pos = 0
	for i in range(Numero_Jogadores):
		if Jogadores[i][0] == id:
			pos = i
	rpc("Remover_Jogador",pos)
	pass
		
func erro_de_conexao():
	pass

func servidor_desconectado():
	get_tree().quit()
	pass
	
remote func Registrar_Jogador(id, novo_nome):
	if get_tree().is_network_server():
		for i in range(Numero_Jogadores):
			rpc_id(id,"Registrar_Jogador",Jogadores[i][0], Jogadores[i][1])
		rpc("Registrar_Jogador", id, novo_nome)	
	Jogadores.append([])
	Jogadores[Numero_Jogadores].append([])
	Jogadores[Numero_Jogadores][0] = id
	Jogadores.append([])
	Jogadores[Numero_Jogadores].append([])
	Jogadores[Numero_Jogadores][1] = novo_nome
	Numero_Jogadores += 1
	
	if Menu != null:
		Menu.Atualizar_Lista_Jogadores()
	pass
	
remotesync func Remover_Jogador(posicao):
	Jogadores.remove(posicao)
	Numero_Jogadores -= 1
	
	if Menu != null:
		Menu.Atualizar_Lista_Jogadores()
	pass

func Mudar_Nome(novo_nome):
	Nome = novo_nome
	pass

func Mudar_Ip(novo_ip):
	Ip = novo_ip
	pass

func Pegar_Lista_Jogadores():
	return Jogadores
	pass

func Pegar_Numero_Jogadores():
	return Numero_Jogadores
	pass
	
func Pegar_Identificador():
	return ID
	pass

func Criar():
	Peer = NetworkedMultiplayerENet.new()
	Peer.create_server(PORTA_BASE, MAX_JOGADORES)
	get_tree().set_network_peer(Peer)
	Peer.connect("peer_disconnected",self,"disconectado_do_servidor")
	ID = get_tree().get_network_unique_id()
	
	Registrar_Jogador(ID,Nome)
	pass

func Entrar():
	Peer = NetworkedMultiplayerENet.new()
	Peer.create_client(Ip, PORTA_BASE)
	get_tree().set_network_peer(Peer)
	ID = get_tree().get_network_unique_id()
	pass

