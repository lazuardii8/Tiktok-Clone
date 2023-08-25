import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/constants.dart';
import 'package:tiktok_clone/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UplaodVideoController extends GetxController {
  _compressVodeo(String videoPart) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPart,
        quality: VideoQuality.MediumQuality);

    return compressedVideo!.file;
  }

  Future<String> _uploadVideoStorage(String id, String videoPart) async {
    Reference ref = firebaseStorage.ref().child("videos").child(id);

    UploadTask uplaodTask = ref.putFile(await _compressVodeo(videoPart));
    TaskSnapshot snap = await uplaodTask;
    String downlaodUrl = await snap.ref.getDownloadURL();
    return downlaodUrl;
  }

  _getThumbnail(String videoPart) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPart);
    return thumbnail;
  }

  Future<String> _uplaodImageToStorage(String id, String videoPart) async {
    Reference ref = firebaseStorage.ref().child("thumbnails").child(id);

    UploadTask uplaodTask = ref.putFile(await _getThumbnail(videoPart));
    TaskSnapshot snap = await uplaodTask;
    String downlaodUrl = await snap.ref.getDownloadURL();
    return downlaodUrl;
  }

  // upload video
  UploadVideo(String songName, String caption, String videoPart) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection("users").doc(uid).get();

      var allDocs = await fireStore.collection("videos").get();
      int len = allDocs.docs.length;

      String videoUrl = await _uploadVideoStorage("Video $len", videoPart);

      String thumbnail = await _uplaodImageToStorage("Video $len", videoPart);

      Video video = Video(
          username: (userDoc.data() as Map<String, dynamic>)["name"],
          uid: uid,
          id: "Video $len",
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnail,
          profilePhoto:
              (userDoc.data() as Map<String, dynamic>)["profilePhoto"]);

      await fireStore
          .collection("videos")
          .doc("Video $len")
          .set(video.toJson());

      Get.back();
    } catch (e) {
      Get.snackbar("Error Uplaoding Video", e.toString());
    }
  }
}
