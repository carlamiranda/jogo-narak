extends Node

#valores emocionais da protagonista
var ansiedade: int = 50
var isolamento: int = 50
var confianca: int = 0
var vinculo_colorida: int = 0
var vinculo_quebrada: int = 0

#guarda informações da rota e do final
var rota_atual: String = ""
var final_atual: String = ""
var atendeu_ligacao: bool = false


#altera os valores emocionais sem deixar passar de 0 a 100
func alterar_estado(
	delta_ansiedade: int,
	delta_isolamento: int,
	delta_confianca: int,
	delta_colorida: int,
	delta_quebrada: int
) -> void:
	ansiedade = clamp(ansiedade + delta_ansiedade, 0, 100)
	isolamento = clamp(isolamento + delta_isolamento, 0, 100)
	confianca = clamp(confianca + delta_confianca, 0, 100)
	vinculo_colorida = clamp(vinculo_colorida + delta_colorida, 0, 100)
	vinculo_quebrada = clamp(vinculo_quebrada + delta_quebrada, 0, 100)


#define qual rota o jogador escolheu
func definir_rota(nova_rota: String) -> void:
	rota_atual = nova_rota


#define qual final o jogador alcançou
func definir_final(novo_final: String) -> void:
	final_atual = novo_final


#decide o final baseado na rota e na ligação
func calcular_final() -> String:
	if rota_atual == "colorida":
		return "superacao"

	if rota_atual == "espelho" and atendeu_ligacao:
		return "despertar"

	if rota_atual == "espelho" and not atendeu_ligacao:
		return "vazio"

	return "indefinido"


#volta todos os valores para o início
func resetar_jogo() -> void:
	ansiedade = 50
	isolamento = 50
	confianca = 0
	vinculo_colorida = 0
	vinculo_quebrada = 0
	rota_atual = ""
	final_atual = ""
	atendeu_ligacao = false
	
