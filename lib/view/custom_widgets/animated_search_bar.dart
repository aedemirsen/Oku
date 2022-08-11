import 'package:flutter/material.dart';
import 'package:yazilar/config/config.dart' as conf;

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late bool _folded;
  @override
  void initState() {
    super.initState();
    _folded = true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: _folded ? 50 : 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(conf.radius),
        //boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: _folded
                  ? TextField(
                      decoration: InputDecoration(
                        hintText: 'Ara',
                        hintStyle: TextStyle(
                          color: Colors.blue[300],
                        ),
                        border: InputBorder.none,
                      ),
                    )
                  : null,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: const Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: const Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _folded ? conf.searchIcon : conf.closeIcon,
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
