function H = cconvmtx2(h)

[block_size, num_blocks] = size(h);
num_elem = block_size*num_blocks;

H1 = spalloc(num_elem, block_size, block_size*nnz(h));%spalloc - 为稀疏矩阵分配空间,nnz - 非零矩阵元素的数目
H = spalloc(num_elem, num_elem, num_elem*nnz(h));

% create the first n columns
for col = 1:block_size
    H1(:,col) = reshape(circshift(h, [col-1 0]), num_elem, 1);%circshift - 循环平移数组,将在列上循环平移col-1位，行上不变，然后将其重塑为一列向量
end

% construct all blocks in H
for block = 1:num_blocks
    H(:,block_size*(block-1)+1:block_size*block) = circshift(H1, [(block-1)*block_size 0]);%可以想象一下，这样是2500x25在列上移动，将2500在列上移动一位可以想象成在移动过像素的行上移动
end
end
