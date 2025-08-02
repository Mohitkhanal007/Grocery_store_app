import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';
import 'package:jerseyhub/features/product/domain/repository/product_repository.dart';
import 'package:jerseyhub/features/product/domain/use_case/get_all_products_usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';

class MockProductRepository extends Mock implements IProductRepository {}

void main() {
  late MockProductRepository mockRepository;
  late GetAllProductsUseCase useCase;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetAllProductsUseCase(repository: mockRepository);
  });

  test('should get all products from repository', () async {
    // Arrange
    final mockProducts = [
      ProductEntity(
        id: '1',
        team: 'Real Madrid',
        type: 'Home',
        size: 'M',
        price: 2500.0,
        quantity: 50,
        categoryId: '1',
        productImage: 'assets/images/Liverpool.png',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    when(
      () => mockRepository.getAllProducts(),
    ).thenAnswer((_) async => Right(mockProducts));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(mockProducts));
    verify(() => mockRepository.getAllProducts()).called(1);
  });

  test('should return failure when repository fails', () async {
    // Arrange
    const failure = RemoteDatabaseFailure(message: 'Failed to fetch products');
    when(
      () => mockRepository.getAllProducts(),
    ).thenAnswer((_) async => const Left(failure));

    // Act
    final result = await useCase();

    // Assert
    expect(result, const Left(failure));
    verify(() => mockRepository.getAllProducts()).called(1);
  });
}
