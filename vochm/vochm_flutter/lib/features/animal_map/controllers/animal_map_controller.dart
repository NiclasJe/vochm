import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:vochm_client/vochm_client.dart' as api;

import '../services/animal_finding_service.dart';
import '../services/animal_service.dart';

class AnimalMapState extends Equatable {
  const AnimalMapState({
    required this.animals,
    required this.findings,
    required this.nearestDistanceByAnimalId,
    required this.isLoading,
    required this.isSubmitting,
    required this.errorMessage,
    required this.lastTappedLocation,
  });

  final List<api.Animal> animals;
  final List<api.AnimalFinding> findings;
  final Map<int, double> nearestDistanceByAnimalId;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final LatLng? lastTappedLocation;

  @override
  List<Object?> get props => [
        animals,
        findings,
        nearestDistanceByAnimalId,
        isLoading,
        isSubmitting,
        errorMessage,
        lastTappedLocation,
      ];

  AnimalMapState copyWith({
    List<api.Animal>? animals,
    List<api.AnimalFinding>? findings,
    Map<int, double>? nearestDistanceByAnimalId,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
    LatLng? lastTappedLocation,
    bool clearLastTappedLocation = false,
  }) {
    return AnimalMapState(
      animals: animals ?? this.animals,
      findings: findings ?? this.findings,
      nearestDistanceByAnimalId: nearestDistanceByAnimalId ?? this.nearestDistanceByAnimalId,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      lastTappedLocation: clearLastTappedLocation ? null : (lastTappedLocation ?? this.lastTappedLocation),
    );
  }

  factory AnimalMapState.initial() => AnimalMapState(
        animals: const [],
        findings: const [],
        nearestDistanceByAnimalId: const {},
        isLoading: false,
        isSubmitting: false,
        errorMessage: null,
        lastTappedLocation: null,
      );
}

class AnimalMapController extends Cubit<AnimalMapState> {
  AnimalMapController({
    required this.animalService,
    required this.animalFindingService,
  }) : super(AnimalMapState.initial());

  final AnimalService animalService;
  final AnimalFindingService animalFindingService;

  List<api.Animal> get animals => state.animals;

  List<api.AnimalFinding> get findings => state.findings;

  Map<int, double> get nearestDistanceByAnimalId => state.nearestDistanceByAnimalId;

  bool get isLoading => state.isLoading;

  bool get isSubmitting => state.isSubmitting;

  String? get errorMessage => state.errorMessage;

  LatLng? get lastTappedLocation => state.lastTappedLocation;

  Future<void> init() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final fetchedAnimals = await animalService.getAllAnimals();
      final fetchedFindings = await animalFindingService.getAllFindings();
      emit(state.copyWith(
        animals: fetchedAnimals,
        findings: fetchedFindings,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> addAnimal(String name) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final animal = await animalService.addAnimal(name);
      final updated = [...state.animals];
      if (!updated.any((a) => a.id == animal.id)) {
        updated.add(animal);
      }
      emit(state.copyWith(animals: updated, isSubmitting: false));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  void onMapTap(LatLng position) {
    emit(state.copyWith(lastTappedLocation: position));
  }

  Future<void> addFindingForAnimal(api.Animal animal) async {
    final location = state.lastTappedLocation;
    if (location == null || animal.id == null) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));
    try {
      final finding = await animalFindingService.insertAnimalFinding(
        animalId: animal.id!,
        latitude: location.latitude,
        longitude: location.longitude,
      );

      final updatedFindings = [...state.findings, finding];
      emit(state.copyWith(findings: updatedFindings, clearLastTappedLocation: true, isSubmitting: false));

      // refresh nearest neighbors for this animal
      await fetchNearestNeighborsForAnimal(animal.id!);
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> fetchNearestNeighborsForAnimal(int animalId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final distanceInMeters = await animalFindingService.getNearestNeighborsForAnimal(animalId);
      final updated = Map<int, double>.from(state.nearestDistanceByAnimalId);
      updated[animalId] = distanceInMeters;
      emit(state.copyWith(nearestDistanceByAnimalId: updated, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  Future<void> test() async {
    try {
      String test = await animalService.test();
      print(test);
      emit(state.copyWith(errorMessage: "Success"));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Test failed"));
    }
  }
}
