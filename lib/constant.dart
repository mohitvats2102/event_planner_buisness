import 'package:flutter/material.dart';

const Color kdarkTeal = Color(0xFF033249);

const TextStyle kloginText = TextStyle(
  color: Color(0xFFFF8038),
  fontSize: 50,
  fontWeight: FontWeight.w400,
);

const InputDecoration klogininput = InputDecoration(
  labelText: 'Name',
  labelStyle: TextStyle(color: Color(0xFFFF8038)),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFFF8038),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(
        10,
      ),
    ),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFFF8038),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(
        10,
      ),
    ),
  ),
);
