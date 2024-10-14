module cuenta::incendios_forestales {
    use aptos_std::vector;
    use std::string::String;
    use std::signer;

////  ESTRUCTURAS 
    struct Bosque has key, store, copy, drop {
        nombre: String,
        ubicacion: String,
        area_hectareas: u64,
        en_peligro: bool,
    }
    
    struct RegistroBosques has key, store {
        bosques: vector<Bosque>,
    }

    struct Recompensa has key, store {
        puntos: u64,
    }

    struct Transferencia has copy, drop, store {
        donante: address,
        destinatario: address,
        puntos: u64,
    }

    struct HistorialTransferencias has key, store {
        transferencias: vector<Transferencia>,
    }

    const E_NOT_INITIALIZED: u64 = 1;

// FUNCIONES
    // Inicializacion del registros
    public fun inicializar_registro_bosques(account: &signer) {
        let direccion_cuenta = signer::address_of(account);
        // assert!(!exists<RegistroBosques>(direccion_cuenta), E_NOT_INITIALIZED);
        move_to(account, RegistroBosques { bosques: vector::empty() });
    }

    public fun inicializar_recompensa(account: &signer) {
        let direccion_cuenta = signer::address_of(account);
        assert!(!exists<Recompensa>(direccion_cuenta), E_NOT_INITIALIZED);
        move_to(account, Recompensa { puntos: 0 });
    }

    public entry fun inicializar_historial(account: &signer) {
        let historial = HistorialTransferencias {
            transferencias: vector::empty(),
        };
        move_to(account, historial);
    }
////////////////////////////////////
    // Funcion para agregar un nuevo bosque al registro

    public entry fun agregar_bosque(
        account: &signer, 
        nombre: String, 
        ubicacion: String, 
        area_hectareas: u64
    ) acquires RegistroBosques, Recompensa { 
        let direccion_cuenta = signer::address_of(account);

        // Asegurarse de que la estructura RegistroBosques ya   inicializada
        if (!exists<RegistroBosques>(direccion_cuenta)) {
            inicializar_registro_bosques(account);
        };
        // Asegurarse de que la estructura Recompensa ya   inicializada
        if (!exists<Recompensa>(direccion_cuenta)) {
            inicializar_recompensa(account);
        };

        let registro_bosques = borrow_global_mut<RegistroBosques>(direccion_cuenta);
        let nuevo_bosque = Bosque {
            nombre,
            ubicacion,
            area_hectareas,
            en_peligro: true,
        };
        vector::push_back(&mut registro_bosques.bosques, nuevo_bosque);

        // Otorgar recompensa si es necesario
        otorgar_recompensa(account, 10);
    }
//////////////////////////////
    // Funcion para marcar un bosque como fuera de peligro
    public entry fun marcar_bosque_fuera_de_peligro(account: &signer, indice_bosque: u64) acquires RegistroBosques {
        let direccion_cuenta = signer::address_of(account);
        let registro_bosques = borrow_global_mut<RegistroBosques>(direccion_cuenta);
        let bosque_mut_ref = vector::borrow_mut(&mut registro_bosques.bosques, indice_bosque);
        bosque_mut_ref.en_peligro = false;
    }

    // Funcion eliminar bosque
    public entry fun eliminar_bosque(account: &signer, indice_bosque: u64) acquires RegistroBosques {
        let registro_bosques = borrow_global_mut<RegistroBosques>(signer::address_of(account));
        vector::remove(&mut registro_bosques.bosques, indice_bosque);
    }

    // Funcion para consultar los bosques registrados
    #[view]
    public fun obtener_bosques(account: address): vector<Bosque> acquires RegistroBosques {
        let registro_ref = borrow_global<RegistroBosques>(account);
        let bosques_copia = *&registro_ref.bosques; // Desreferenciar y luego referenciar para obtener una copia
        bosques_copia // Retornar la copia del vector de bosques
    }

    // Funcion para Contar los Bosques Registrados
    #[view]
    public fun contar_bosques(account: address): u64 acquires RegistroBosques {
        let registro_ref = borrow_global<RegistroBosques>(account);
        vector::length(&registro_ref.bosques)
    }

 //============================================================
    // Funcion para otorgar puntos de recompensa
    public fun otorgar_recompensa(account: &signer, puntos: u64) acquires Recompensa {
        let recompensa_ref = borrow_global_mut<Recompensa>(signer::address_of(account));
        recompensa_ref.puntos = recompensa_ref.puntos + puntos;
    }

    // Funcion para consultar puntos de recompensa
    #[view]
    public fun consultar_recompensa(account: address): u64 acquires Recompensa {
        let recompensa_ref = borrow_global<Recompensa>(account);
        recompensa_ref.puntos
    }

    // Funcion para transferir puntos de recompensa de una cuenta a otra
    public entry fun transferir_recompensa(
        donante: &signer,
        destinatario: address,
        puntos: u64
    ) acquires Recompensa {
        // Acceder a la recompensa del donante y reducir los puntos
        let recompensa_donante = borrow_global_mut<Recompensa>(signer::address_of(donante));
        assert!(recompensa_donante.puntos >= puntos, 1); // Asegurarse de que hay suficientes puntos
        recompensa_donante.puntos = recompensa_donante.puntos - puntos;

        // Acceder a la recompensa del destinatario y aumentar los puntos
        let recompensa_destinatario = borrow_global_mut<Recompensa>(destinatario);
        recompensa_destinatario.puntos = recompensa_destinatario.puntos + puntos;

        // // Registrar la transferencia en el historial
        // registrar_transferencia(signer::address_of(donante), destinatario, puntos);
    }

 //=============================================
    public entry fun registrar_transferencia(donante: address, destinatario: address, puntos: u64) acquires HistorialTransferencias {
        assert!(exists<HistorialTransferencias>(donante), 42); // 42 es un codigo de error arbitrario
        let historial_ref = borrow_global_mut<HistorialTransferencias>(donante);
        let transferencia = Transferencia {
            donante,
            destinatario,
            puntos,
        };
        vector::push_back(&mut historial_ref.transferencias, transferencia);
    }
  
    #[view]
    public fun ver_historial(donante: address): vector<Transferencia> acquires HistorialTransferencias {
        let historial_ref = borrow_global<HistorialTransferencias>(donante);
        historial_ref.transferencias
    }
}