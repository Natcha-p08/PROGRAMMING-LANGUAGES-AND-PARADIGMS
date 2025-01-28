fun findCageSize(catSizes: List<Int>): Int {
    // จัดกลุ่มขนาดของแมวและตรวจสอบคู่แมวที่ไม่ได้อยู่ติดกัน
    val unmatchedSizes = catSizes.withIndex()
        .groupBy({ it.value }, { it.index })
        .filter { (_, indices) ->
            // ค้นหาขนาดที่มีคู่แมวไม่ได้อยู่ติดกัน
            indices.zipWithNext().any { (a, b) -> b != a + 1 }
        }
        .keys
    // ส่งคืนขนาดที่ใหญ่ที่สุดในบรรดาคู่ที่ไม่ได้อยู่ติดกัน
    return unmatchedSizes.maxOrNull() ?: 0
}
fun main() {
    // รับจำนวนแมวจากผู้ใช้ ถ้าไม่ใช่จำนวนเต็ม ให้แสดง "Invalid input" และจบการทำงาน
    val n = readLine()?.toIntOrNull() ?: return println("Invalid input.")
    // ตรวจสอบว่า n เป็นจำนวนเต็มคู่หรือไม่
    if (n % 2 != 0) {
        println("The number of cats must be an even integer.")
        return
    }
    // อ่านขนาดของแมวทีละบรรทัด
    val catSizes = mutableListOf<Int>()
    repeat(n) {
        val size = readLine()?.toIntOrNull()
        if (size != null) {
            // ถ้า input เป็นจำนวนเต็ม ให้เพิ่มไปในรายการ catSizes
            catSizes.add(size)
        } else {
            // ถ้า input ไม่ใช่จำนวนเต็ม ให้แสดง "Invalid input" และจบการทำงาน
            return
        }
    }
    // คำนวณขนาดกรงที่เล็กที่สุดที่ต้องการสำหรับแมว
    val cageSize = findCageSize(catSizes)
    // แสดงขนาดกรงที่เหมาะสม
    println("$cageSize")
}
