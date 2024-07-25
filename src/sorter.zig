pub fn buddle_sort(arr: []i32) void {
    const n = arr.len;
    for (0..n - 1) |i| {
        for (i + 1..n) |j| {
            var minIndex = i;

            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }

            if (minIndex != i) {
                const tmp = arr[i];
                arr[i] = arr[minIndex];
                arr[minIndex] = tmp;
            }
        }
    }
}
