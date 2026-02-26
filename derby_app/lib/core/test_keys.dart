/// Keys centralizadas para tests de UI.
///
/// Usar estas keys permite localizar widgets de forma confiable en tests
/// sin depender de textos que pueden cambiar.
library;

import 'package:flutter/foundation.dart';

/// Keys para la pantalla de sorteo
class SorteoKeys {
  SorteoKeys._();

  static const btnGenerarPreview = Key('btn_generar_preview');
  static const btnAprobarSorteo = Key('btn_aprobar_sorteo');
  static const btnDescartarSorteo = Key('btn_descartar_sorteo');
  static const btnNuevoSorteo = Key('btn_nuevo_sorteo');
  static const btnExportarPdf = Key('btn_exportar_pdf_sorteo');
  static const cardResumen = Key('card_resumen_sorteo');
  static const cardValidaciones = Key('card_validaciones');
  static const tablaRondas = Key('tabla_rondas');
  static const indicadorProgreso = Key('indicador_progreso_sorteo');
}

/// Keys para la pantalla de gallos
class GallosKeys {
  GallosKeys._();

  static const fabAgregarGallo = Key('fab_agregar_gallo');
  static const btnAgregarGalloEmpty = Key('btn_agregar_gallo_empty');
  static const inputAnillo = Key('input_anillo');
  static const inputPeso = Key('input_peso');
  static const dropdownParticipante = Key('dropdown_participante');
  static const btnGuardarGallo = Key('btn_guardar_gallo');
  static const btnCancelarGallo = Key('btn_cancelar_gallo');
  static const btnEliminarGallo = Key('btn_eliminar_gallo');
  static const btnRetirarGallo = Key('btn_retirar_gallo');
  static const btnDescalificarGallo = Key('btn_descalificar_gallo');
  static const gridGallos = Key('grid_gallos');

  static Key galloCard(String id) => Key('gallo_card_$id');
  static Key galloMenu(String id) => Key('gallo_menu_$id');
}

/// Keys para la pantalla de participantes
class ParticipantesKeys {
  ParticipantesKeys._();

  static const fabAgregarParticipante = Key('fab_agregar_participante');
  static const btnAgregarParticipanteEmpty = Key(
    'btn_agregar_participante_empty',
  );
  static const inputNombre = Key('input_nombre_participante');
  static const inputEquipo = Key('input_equipo');
  static const inputTelefono = Key('input_telefono');
  static const btnGuardarParticipante = Key('btn_guardar_participante');
  static const btnCancelarParticipante = Key('btn_cancelar_participante');
  static const btnEliminarParticipante = Key('btn_eliminar_participante');
  static const btnEditarCompadres = Key('btn_editar_compadres');
  static const listaParticipantes = Key('lista_participantes');

  static Key participanteRow(String id) => Key('participante_row_$id');
  static Key participanteMenu(String id) => Key('participante_menu_$id');
}

/// Keys para la pantalla de peleas
class PeleasKeys {
  PeleasKeys._();

  static const btnRondaAnterior = Key('btn_ronda_anterior');
  static const btnRondaSiguiente = Key('btn_ronda_siguiente');
  static const btnExportarPdf = Key('btn_exportar_pdf_ronda');
  static const btnVerHojaFisica = Key('btn_ver_hoja_fisica');
  static const bannerRondaBloqueada = Key('banner_ronda_bloqueada');
  static const btnDesbloquearRonda = Key('btn_desbloquear_ronda');
  static const barraProgreso = Key('barra_progreso_ronda');
  static const listaPeleas = Key('lista_peleas');

  static Key peleaCard(String id) => Key('pelea_card_$id');
  static Key btnGanaRojo(String peleaId) => Key('btn_gana_rojo_$peleaId');
  static Key btnGanaVerde(String peleaId) => Key('btn_gana_verde_$peleaId');
  static Key btnEmpate(String peleaId) => Key('btn_empate_$peleaId');
  static Key btnDeshacer(String peleaId) => Key('btn_deshacer_$peleaId');
}

/// Keys para la pantalla de configuración
class ConfiguracionKeys {
  ConfiguracionKeys._();

  static const inputNumeroRondas = Key('input_numero_rondas');
  static const inputTolerancia = Key('input_tolerancia');
  static const inputPuntosVictoria = Key('input_puntos_victoria');
  static const inputPuntosDerrota = Key('input_puntos_derrota');
  static const inputPuntosEmpate = Key('input_puntos_empate');
  static const btnGuardarConfig = Key('btn_guardar_config');
  static const btnActivarLicencia = Key('btn_activar_licencia');
  static const inputCodigoLicencia = Key('input_codigo_licencia');
  static const btnExportarBackup = Key('btn_exportar_backup');
  static const btnImportarBackup = Key('btn_importar_backup');
  static const btnRepararLicencias = Key('btn_reparar_licencias');
  static const btnVerRutaBd = Key('btn_ver_ruta_bd');
  static const btnVerHistorial = Key('btn_ver_historial');
}

/// Keys para el dashboard
class DashboardKeys {
  DashboardKeys._();

  static const cardEstadisticas = Key('card_estadisticas');
  static const cardPosiciones = Key('card_posiciones');
  static const btnNuevoDerby = Key('btn_nuevo_derby');
  static const btnImportarDerby = Key('btn_importar_derby');
  static const indicadorLicencia = Key('indicador_licencia');
  static const tablaPosiciones = Key('tabla_posiciones');
}

/// Keys para la shell/navegación
class ShellKeys {
  ShellKeys._();

  static const navDashboard = Key('nav_dashboard');
  static const navParticipantes = Key('nav_participantes');
  static const navGallos = Key('nav_gallos');
  static const navSorteo = Key('nav_sorteo');
  static const navPeleas = Key('nav_peleas');
  static const navResultados = Key('nav_resultados');
  static const navConfiguracion = Key('nav_configuracion');
}

/// Keys para diálogos comunes
class DialogKeys {
  DialogKeys._();

  static const dialogConfirmacion = Key('dialog_confirmacion');
  static const btnConfirmar = Key('btn_confirmar_dialog');
  static const btnCancelar = Key('btn_cancelar_dialog');
  static const dialogError = Key('dialog_error');
  static const dialogExito = Key('dialog_exito');
}
