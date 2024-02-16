import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarItem extends StatefulWidget {

  AvatarItem({super.key, required this.onSelected, required this.isSelected, required this.index, required this.url, required this.baseUrl});

  final int index;
  final String url;
  final String baseUrl;
  final Function(int) onSelected;
  final bool isSelected;

  @override
  State<AvatarItem> createState() => _AvatarItemState();
}

class _AvatarItemState extends State<AvatarItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(widget.index);
      },
      child: Container(
        decoration: BoxDecoration(
          border: widget.isSelected
              ? Border.all(color: const Color(0xFF27D7F6), width: 2.0)
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: CachedNetworkImage(
          key: ValueKey(widget.baseUrl + widget.url ),
          fit: BoxFit.fitHeight,
          placeholder: (context, url) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const SizedBox(),
            );
          },
          imageUrl: widget.baseUrl + widget.url,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text('image_loading_error'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}

