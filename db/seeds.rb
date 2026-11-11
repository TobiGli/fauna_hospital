MedicalRecord.destroy_all
Patient.destroy_all
Species.destroy_all

carpincho = Species.create!(
  common_name: "Carpincho",
  scientific_name: "Hydrochoerus hydrochaeris",
  taxonomy_class: "Mamífero",
  conservation_status: "Preocupación Menor"
)

loro_hablador = Species.create!(
  common_name: "Loro Hablador",
  scientific_name: "Amazona aestiva",
  taxonomy_class: "Ave",
  conservation_status: "Casi Amenazado"
)

tortuga_terrestre = Species.create!(
  common_name: "Tortuga Terrestre",
  scientific_name: "Chelonoidis chilensis",
  taxonomy_class: "Reptil",
  conservation_status: "Vulnerable"
)

carpincho_patient = carpincho.patients.create!(
  identifier: "CAR-001",
  name: "Tito",
  admission_date: Date.current,
  status: "En observación",
  custom_metrics: {
    incisivos_desgastados: true,
    dieta_basada_en_gramineas: true
  }
)

carpincho_patient.medical_records.create!(
  weight: 42.5,
  temperature: 38.2,
  diagnosis: "Deshidratación leve",
  treatment_plan: "Hidratación y observación clínica"
)

loro_patient = loro_hablador.patients.create!(
  identifier: "LOR-001",
  name: "Pepe",
  admission_date: Date.current,
  status: "En tratamiento",
  custom_metrics: {
    envergadura_alar_cm: 45,
    recorte_vuelo_previo: false
  }
)

loro_patient.medical_records.create!(
  diagnosis: "Traumatismo en ala derecha",
  treatment_plan: "Inmovilización y control radiográfico"
)

tortuga_patient = tortuga_terrestre.patients.create!(
  identifier: "TOR-001",
  name: "Pacha",
  admission_date: Date.current,
  status: "En recuperación",
  custom_metrics: {
    largo_caparazon_cm: 25,
    piramidismo: true,
    sexo_prob: "Macho"
  }
)

tortuga_patient.medical_records.create!(
  diagnosis: "Déficit nutricional severo",
  treatment_plan: "Suplementación nutricional y seguimiento veterinario"
)
