# Incendios forestales y conservación de Bosques en Blockchain - Aptos Move

#Explorador de Aptos Labs
https://explorer.aptoslabs.com/account/0x031354d636fa710507069937b7e9124ddf77c0b8cb753ce3f10ac78a8ee20d8f?network=devnet

Este repositorio contiene un proyecto de conservación de bosques implementado en **Aptos Move**, que utiliza blockchain para incentivar la protección y preservación de los bosques mediante el registro de bosques y la distribución de recompensas.

## Objetivo del Proyecto

El objetivo principal de este proyecto es crear un sistema basado en blockchain que permita rastrear, registrar y proteger bosques en Sudamérica, especialmente en áreas afectadas por quemas, como Brasil, Perú, y Bolivia. Este sistema utiliza un enfoque basado en incentivos, donde los usuarios pueden recibir y transferir recompensas para apoyar la conservación de los bosques.

## Funcionalidades Principales

### 1. Registro y Conservación de Bosques

- **Estructura `Bosque`**: Se utiliza para representar los atributos básicos de cada bosque, como el nombre, ubicación, área en hectáreas y si está en peligro.
- **`inicializar_registro`**: Inicializa el registro de bosques para cada cuenta.
- **`agregar_bosque`**: Permite agregar un nuevo bosque al registro de la cuenta, incentivando la conservación.
- **`marcar_bosque_en_peligro`**: Marca un bosque como en peligro de desaparecer, actualizando el estado.
- **`obtener_bosques`**: Permite consultar todos los bosques registrados por una cuenta.
- **`eliminar_bosque`**: Elimina un bosque del registro de la cuenta.
- **`contar_bosques`**: Cuenta el número total de bosques registrados.

### 2. Sistema de Recompensas

- **Estructura `Recompensa`**: Almacena los puntos de recompensa de cada usuario.
- **`inicializar_recompensa`**: Inicializa el sistema de recompensas con `0` puntos para una cuenta.
- **`otorgar_recompensa`**: Otorga puntos de recompensa cuando un usuario realiza acciones positivas, como agregar un bosque.
- **`consultar_recompensa`**: Permite a los usuarios consultar la cantidad de puntos acumulados.
- **`transferir_recompensa`**: Permite transferir puntos de recompensa de una cuenta a otra, promoviendo la colaboración en la conservación.

### 3. Registro de Transferencias

- **Estructura `HistorialTransferencias`**: Lleva un historial de todas las transferencias de recompensas realizadas entre cuentas.
- **`inicializar_historial`**: Inicializa el historial de transferencias para una cuenta.
- **`registrar_transferencia`**: Registra cada transferencia realizada, incluyendo el donante, el destinatario y la cantidad de puntos transferidos.

## Uso del Sistema de Recompensas

1. **Inicializar Recursos**: Primero, cada cuenta debe inicializar su registro de bosques, su recompensa y su historial de transferencias:

   ```move
   inicializar_recursos(account);
