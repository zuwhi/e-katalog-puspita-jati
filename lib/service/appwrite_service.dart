import 'dart:io' as io;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/constant/appwrite_constants.dart';
import 'package:e_katalog/model/about_model.dart';
import 'package:e_katalog/model/cart_model.dart';
import 'package:e_katalog/model/colors_model.dart';
import 'package:e_katalog/model/product_image_model.dart';
import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/model/result.dart';
import 'package:e_katalog/model/user_model.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class AppwriteService extends GetxService {
  Client client = Client();
  late Account account;
  late Databases databases;
  late Storage storage;

  Future<AppwriteService> init() async {
    client
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId)
        .setSelfSigned(status: true);
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    return this;
  }

  Future<Result> getAboutDesc() async {
    try {
      final result = await databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.aboutCollectionID);

      return Result.success(result.documents[0].data);
    } catch (e) {
      return Result.failed(e.toString());
    }
  }

  Future<Result> addColors(ColorsModel colors) async {
    try {
      await databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.colorsCollectionID,
          documentId: ID.unique(),
          data: {"color": colors.color, "name": colors.name});
      return const Result.success("success");
    } catch (e) {
      return Result.failed(e.toString());
    }
  }

  Future<Result> deleteColor(String id) async {
    try {
      await databases.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.colorsCollectionID,
          documentId: id);
      return const Result.success("success");
    } catch (e) {
      print(e);
      return Result.failed(e.toString());
    }
  }

  Future<Result> updateAboutDesc(AboutModel? aboutModel) async {
    try {
      await databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.aboutCollectionID,
          documentId: aboutModel?.id ?? "",
          data: {
            "title": aboutModel?.title,
            "desc": aboutModel?.desc,
            "telepon": aboutModel?.telepon,
            "email": aboutModel?.email,
            "website": aboutModel?.website,
            "alamat": aboutModel?.alamat,
            "koordinat": aboutModel?.koordinat,
          });
      return const Result.success("success");
    } catch (e) {
      return Result.failed(e.toString());
    }
  }

  Future<Result> getColorsList() async {
    try {
      final result = await databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.colorsCollectionID);
      Logger().d(result);
      List<ColorsModel> colors =
          result.documents.map((e) => ColorsModel.fromMap(e.data)).toList();
      return Result.success(colors);
    } catch (e) {
      Logger().d(e);
      return Result.failed(e.toString());
    }
  }

  Future<Result> addDataCart(CartModel cart) async {
    try {
      await databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.cartCollectionId,
          documentId: ID.unique(),
          data: {
            "userId": cart.userId,
            "product": cart.product!.id,
            "colors": cart.colors,
          });

      return const Result.success(true);
    } catch (e) {
      print(e);
      return const Result.failed("error");
    }
  }

  Future<String?> getNumberAdmin() async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        queries: [Query.equal('role', 'admin')],
      );
      Logger().d(response.documents[0].data['telepon']);
      Logger().d(response.documents[0]);

      return response.documents[0].data['telepon'];
    } catch (e) {
      throw "tidak bisa menemukan nomor admin";
    }
  }

  Future<Result<List<CartModel>>> getDataCartByUserId(String userId) async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cartCollectionId,
        queries: [Query.equal('userId', userId)],
      );

      // Periksa apakah ada dokumen yang diterima
      if (response.documents.isEmpty) {
        return const Result.failed('No data found');
      }

      // Konversi list menjadi List<ProductModel>
      List<CartModel> carts =
          response.documents.map((e) => CartModel.fromMap(e.data)).toList();

      return Result.success(carts);
    } catch (e) {
      print(e);
      return Result.failed(e.toString());
    }
  }

  Future<Result> deleteCart(String id) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.cartCollectionId,
        documentId: id,
      );
      return const Result.success(true);
    } catch (e) {
      return Result.failed(e.toString());
    }
  }

  Future<User> createAccount(
      {required String email, required String password}) async {
    try {
      final result = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      print("cek result created akun");
      Logger().d(result);
      // Logger().d(result.toMap());
      return result;
    } on AppwriteException catch (e) {
      if (e.code == 409) {
        throw 'Email sudah digunakan, silahkan gunakan email lain';
      }
      throw 'terjadi kesalahan saat register';
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUserDocument(String userId, UserModel user) async {
    try {
      await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: userId,
        data: {
          "name": user.name,
          "role": user.role,
          "telepon": user.telepon,
          "alamat": user.alamat,
          "image": user.image
        },
      );
    } catch (e) {
      throw Exception('terjadi kesalahan saat register');
    }
  }

  Future<UserModel> getUserDocument(String userId) async {
    try {
      final userAuth = await account.get();

      final userDocument = await databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: userId,
      );

      UserModel userDocumentModel = UserModel.fromMap(userDocument.data);
      UserModel user = userDocumentModel.copyWith(
        id: userAuth.$id,
        email: userAuth.email,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserDocument(UserModel user, io.File? image) async {
    try {
      String? imageUrl;
      String? bucketId;
      if (user.name != null) {
        await account.updateName(name: user.name!);
      }

      if (image != null) {
        final responseImg = await storage.createFile(
          bucketId: AppwriteConstants.profileImageID,
          fileId: ID.unique(),
          file: InputFile.fromPath(
            path: image.path,
            filename: image.path.split('/').last,
          ),
        );
        imageUrl =
            '${AppwriteConstants.endpoint}/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=${AppwriteConstants.projectId}&mode=admin';
        bucketId = responseImg.$id;
        if (user.bucketId != null) {
          await storage.deleteFile(
            bucketId: AppwriteConstants.profileImageID,
            fileId: user.bucketId!,
          );
        }
      }

      Map<String, dynamic> data = {
        "name": user.name,
        "role": user.role,
        "telepon": user.telepon,
        "alamat": user.alamat,
      };
      if (imageUrl != null) {
        data['image'] = imageUrl;
        data['bucketId'] = bucketId;
      }

      await databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.userCollectionId,
          documentId: user.id!,
          data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> createSession(
      {required String email, required String password}) async {
    try {
      final result = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      return result;
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        throw ' email dan password salah';
      }
      throw 'terjadi kesalahan saat login, pastikan internet anda terhubung';
    } catch (e) {
      throw 'terjadi kesalahan saat login, pastikan internet anda terhubung';
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      Get.offAllNamed(AppRoute.home);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>?> getProduct() async {
    try {
      final response = await databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.productCollectionId,
          queries: [Query.orderDesc("\$createdAt")]);

      return response.documents
          .map((e) => ProductModel.fromMap(e.data))
          .toList();
    } catch (e) {}
    return null;
  }

  Future<List<ProductModel>?> getProductByCategory(String category) async {
    try {
      final response = await databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.productCollectionId,
          queries: [
            Query.equal("category", category),
            Query.orderDesc("\$createdAt")
          ]);
      return response.documents
          .map((e) => ProductModel.fromMap(e.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String?>> uploadImage(io.File? image) async {
    if (image == null) {
      return [];
    }
    try {
      final responseImg = await storage.createFile(
        bucketId: AppwriteConstants.productImageId,
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: image.path,
          filename: image.path.split('/').last,
        ),
      );
      String urlImage =
          '${AppwriteConstants.endpoint}/storage/buckets/${responseImg.bucketId}/files/${responseImg.$id}/view?project=${AppwriteConstants.projectId}&mode=admin';
      Logger().d(urlImage);

      List<String?> result = [responseImg.$id, urlImage];
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Result> addProduct(
      ProductModel product, ProductImageModel productImages) async {
    try {
      List<String?> list1 = await uploadImage(productImages.image1);
      List<String?> list2 = await uploadImage(productImages.image2);
      List<String?> list3 = await uploadImage(productImages.image3);

      final result = await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.productCollectionId,
        documentId: ID.unique(),
        data: {
          "title": product.title,
          "desc": product.desc,
          "price": product.price,
          "estimate": product.estimate,
          "image1": list1[1],
          "image2": list2[1],
          "image3": list3[1],
          "category": product.category,
          "date": product.date,
          "bucket1": list1[0],
          "bucket2": list2[0],
          "bucket3": list3[0],
        },
      );

      return const Result.success(true);
    } on AppwriteException catch (e) {
      print(e);
      Logger().d(e.message);
      return Result.failed(e.message ?? 'terjadi kesalahan menambahkan produk');
    }
  }

  Future<bool> updateProduct(
      ProductModel product, ProductImageModel productImages) async {
    try {
      List<String?> list1 = [];
      List<String?> list2 = [];
      List<String?> list3 = [];

      if (productImages.image1 != null) {
        list1 = await uploadImage(productImages.image1);
        await deleteImage(product.bucket1!);
      }
      if (productImages.image2 != null) {
        list2 = await uploadImage(productImages.image2);
        await deleteImage(product.bucket2!);
      }
      if (productImages.image3 != null) {
        list3 = await uploadImage(productImages.image3);
        await deleteImage(product.bucket3!);
      }

      Map<String, dynamic> data = {
        "title": product.title,
        "desc": product.desc,
        "price": product.price,
        "estimate": product.estimate,
        "color": product.color,
        "category": product.category,
      };

      if (list1.isNotEmpty) {
        data['bucket1'] = list1[0];
        data['image1'] = list1[1];
      }
      if (list2.isNotEmpty) {
        data['bucket2'] = list2[0];
        data['image2'] = list2[1];
      }
      if (list3.isNotEmpty) {
        data['bucket3'] = list3[0];
        data['image3'] = list3[1];
      }

      final result = await databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.productCollectionId,
        documentId: product.id,
        data: data,
      );

      print(result);
      print("berhasil");

      return true;
    } on AppwriteException catch (e) {
      Logger().d(e.message);
      return false;
    }
  }

  Future<void> deleteProduct(String documentId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.productCollectionId,
        documentId: documentId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage(String fileId) async {
    try {
      if (fileId == "") return;
      await storage.deleteFile(
        bucketId: AppwriteConstants.productImageId,
        fileId: fileId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
