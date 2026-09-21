/// Domain and data layers, shared by every app in the workspace.
library;

export 'src/data/datasources/appointment_datasource.dart';
export 'src/data/models/appointment_model.dart';
export 'src/data/models/paginated_model.dart';
export 'src/data/repositories/appointment_repository_impl.dart';
export 'src/domain/entities/appointment.dart';
export 'src/domain/entities/paginated.dart';
export 'src/domain/failures/app_failure.dart';
export 'src/domain/repositories/appointment_repository.dart';
export 'src/domain/usecases/cancel_appointment_usecase.dart';
export 'src/domain/usecases/get_appointment_usecase.dart';
export 'src/domain/usecases/get_appointments_usecase.dart';
export 'src/domain/usecases/save_appointment_usecase.dart';
export 'src/shared/storage.dart';
export 'injections.dart';
