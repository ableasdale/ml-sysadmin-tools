import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

// Fast NIO file comparison
// Source: https://javax0.wordpress.com/2018/01/31/comparing-files-in-java/

public class Compare {
    public static void main(String[] args) throws IOException {
        long start = System.nanoTime();
        // TODO - use XQuery (XCC) to get correct data directory path
        String path = "/Users/ableasdale/Library/Application Support/MarkLogic/Data/";
        FileChannel ch1 = new RandomAccessFile(path+"clusters.xml", "r").getChannel();
        FileChannel ch2 = new RandomAccessFile(path+"clusters_1.xml", "r").getChannel();
        if (ch1.size() != ch2.size()) {
            System.out.println("Files have different length");
            return;
        }
        long size = ch1.size();
        ByteBuffer m1 = ch1.map(FileChannel.MapMode.READ_ONLY, 0L, size);
        ByteBuffer m2 = ch2.map(FileChannel.MapMode.READ_ONLY, 0L, size);
        for (int pos = 0; pos < size; pos++) {
            if (m1.get(pos) != m2.get(pos)) {
                System.out.println("Files differ at position " + pos);
                return;
            }
        }
        System.out.println("Files are identical, you can delete one of them.");
        long end = System.nanoTime();
        System.out.print("Execution time: " + (end - start) / 1000000 + "ms");
    }
}